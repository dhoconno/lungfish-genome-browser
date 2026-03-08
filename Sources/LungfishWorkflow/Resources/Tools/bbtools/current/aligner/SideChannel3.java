package aligner;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicLong;

import dna.Data;
import fileIO.FileFormat;
import jgi.BBDuk;
import shared.Timer;
import shared.Tools;
import stream.ConcurrentReadOutputStream;
import stream.Read;
import stream.ReadStreamByteWriter;
import stream.SamLine;

public class SideChannel3 {
	
	/*--------------------------------------------------------------*/
	/*----------------          Constructor         ----------------*/
	/*--------------------------------------------------------------*/
	
	public SideChannel3(String ref_, String out_, int k1_, float minid1, 
			int midMaskLen1, boolean overwrite_, boolean ordered_) {
		this(ref_, out_, k1_, -1, minid1, 1, midMaskLen1, 0, overwrite_, ordered_);
	}
	
	public SideChannel3(String ref_, String out_, int k1_, int k2_, float minid1, float minid2, 
			int midMaskLen1, int midMaskLen2, boolean overwrite_, boolean ordered_) {
		Timer t=new Timer();
		ref=fixRefPath(ref_);
		out=out_;
		k1=Tools.max(k1_, k2_);
		k2=Tools.min(k1_, k2_);
		minIdentity1=fixID(minid1);
		minIdentity2=fixID(minid2);
		overwrite=overwrite_;
		ordered=ordered_;
		assert(k1>0);
		
		ffout=FileFormat.testOutput(out, FileFormat.SAM, null, true, overwrite, false, ordered);
		samOut=(ffout!=null && ffout.samOrBam());
		final Read r=MicroIndex3.loadRef(ref, samOut);
		index1=new MicroIndex3(k1, midMaskLen1, r);
		index2=(k2<1 ? null : new MicroIndex3(k2, midMaskLen2, r));
		mapper1=new MicroAligner3(index1, minIdentity1);
		mapper2=(k2<1 ? null : new MicroAligner3(index2, minIdentity2));
		
		if(ffout!=null) {
			if(samOut) {ReadStreamByteWriter.USE_ATTACHED_SAMLINE=true;}
			cros=ConcurrentReadOutputStream.getStream(ffout, null, 12, null, false);
			cros.start();
		}else {cros=null;}
		t.stop("Created side channel"+(out==null ? "" : (" for "+out))+": ");
	}
	
	/*--------------------------------------------------------------*/
	/*----------------            Methods           ----------------*/
	/*--------------------------------------------------------------*/
	
	public void write(ArrayList<Read> reads, long num) {
		if(cros==null || reads==null || (!ordered && reads.isEmpty())) {return;}
		if(samOut && ReadStreamByteWriter.USE_ATTACHED_SAMLINE) {//Could increase concurrency; hard to test with a slow filesystem
			for(Read r1 : reads) {
				Read r2=r1.mate;
				r1.samline=(r1.samline!=null ? r1.samline : new SamLine(r1, 0));
				if(r2!=null) {r2.samline=(r2.samline!=null ? r2.samline : new SamLine(r2, 1));}
			}
		}
		cros.add(reads, num);
	}
	
	public boolean map(Read r1, Read r2) {
		return map(r1, r2, mapper1, mapper2);
	}
	
	public boolean map(Read r1, Read r2, MicroAligner3 mapper1, MicroAligner3 mapper2) {
		float id1=mapper1.map(r1);
		float id2=mapper1.map(r2);
		if(id1+id2<=0) {return false;}//Common case
		
		if(r2!=null) {
			if(mapper2!=null) {
				if(r1.mapped() && !r2.mapped()) {id2=mapper2.map(r2);}
				else if(r2.mapped() && !r1.mapped()) {id1=mapper2.map(r1);}
			}
			boolean properPair=(r1.mapped() && r2.mapped() && r1.chrom==r2.chrom && 
					r1.strand()!=r2.strand() && Tools.absdif(r1.start, r2.start)<=1000);
			r1.setPaired(properPair);
			r2.setPaired(properPair);
		}
		
		if(!r1.mapped()) {id1=0;}
		if(r2==null || !r2.mapped()) {id2=0;}
		long idsum=(long)((id1+id2)*10000);
		if(idsum<=0) {return false;}
		
		if(TRACK_STATS) {
			long rsum=(id1>0 ? 1 : 0)+(id2>0 ? 1 : 0);
			long bsum=(id1>0 ? r1.length() : 0)+(id2>0 ? r2.length() : 0);
			if(ATOMIC) {
				readsOutA.addAndGet(rsum);
				basesOutA.addAndGet(bsum);
				identitySumA.addAndGet(idsum);
			}else {
				synchronized(this) {
					readsOut+=rsum;
					basesOut+=bsum;
					identitySum+=idsum;
				}
			}
		}
		return true;
	}
	
	public String stats(long readsIn, long basesIn) {
		long scr, scb, sci;
		if(ATOMIC) {scr=readsOutA.get(); scb=basesOutA.get(); sci=identitySumA.get();}
		else {scr=readsOut; scb=basesOut; sci=identitySum;}
		String s=("Aligned reads:          \t"+scr+" reads ("+BBDuk.toPercent(scr, readsIn)+") \t"+
				+scb+" bases ("+BBDuk.toPercent(scb, basesIn)+") \tavgID="+Tools.format("%.4f", sci/(100.0*scr)));
		return s;
	}
	
	/*--------------------------------------------------------------*/
	/*----------------        Static Methods        ----------------*/
	/*--------------------------------------------------------------*/
	
	public static int[] parseK(String arg, String a, String b) {
		int[] ret=new int[2];
		String[] terms=b.split(",");
		for(int i=0; i<terms.length; i++) {
			ret[i]=Integer.parseInt(terms[i]);
		}
		return ret;
	}
	
	private static float fixID(float id) {
		if(id>1) {id=id/100;}
		assert(id<=1);
		return id;
	}
	
	private static String fixRefPath(String refPath) {
		if(refPath==null || Tools.isReadableFile(refPath)) {return refPath;}
		if("phix".equalsIgnoreCase(refPath)){return Data.findPath("?phix2.fa.gz");}
		return refPath;
	}
	
	/*--------------------------------------------------------------*/
	/*----------------            Fields            ----------------*/
	/*--------------------------------------------------------------*/

	public final MicroIndex3 index1;
	public final MicroIndex3 index2;
	public final MicroAligner3 mapper1;
	public final MicroAligner3 mapper2;
	
	public final int k1;
	public final int k2;
	public final float minIdentity1;
	public final float minIdentity2;
	
	public final String ref;
	public final String out;
	public final boolean samOut;
	public final FileFormat ffout;
	public final ConcurrentReadOutputStream cros;
	
	//Test speed of these; probably need to be removed.
	public final AtomicLong readsOutA=new AtomicLong(0);
	public final AtomicLong basesOutA=new AtomicLong(0);
	public final AtomicLong identitySumA=new AtomicLong(0);//x100%; 0-10000 scale. 
	
	public long readsOut=0;
	public long basesOut=0;
	public long identitySum=0;//x100%; 0-10000 scale. 
	
	public final boolean overwrite;
	public final boolean ordered;
	
	/*--------------------------------------------------------------*/
	/*----------------           Statics            ----------------*/
	/*--------------------------------------------------------------*/
	
	public static final boolean ATOMIC=false;
	public static boolean TRACK_STATS=true;

}
