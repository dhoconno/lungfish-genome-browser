package ml;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.BitSet;
import java.util.Random;

import shared.Shared;
import shared.Tools;
import shared.Vector;
import structures.ByteBuilder;
import structures.FloatList;
import structures.IntList;

public class CellNet implements Cloneable, Comparable<CellNet> {
	
	/*--------------------------------------------------------------*/
	/*----------------        Initialization        ----------------*/
	/*--------------------------------------------------------------*/

	public CellNet() {//Dummy network
		seed=0;
		dims=null;
		density=1;
		density1=0;
		edgeBlockSize=1;
		layers=0;
		values=null;
		weightsIn=weightsOut=null;
		eOverNet=null;
		list=null;
		net=null;
		finalLayer=null;
		transposeCounter=null;
		layerStart=null;
	}
	
	public CellNet(int[] dims_, long seed_, float density_, float density1_, 
			int edgeBlockSize_, ArrayList<String> commands_) {
		seed=(seed_>=0 ? seed_ : new Random().nextLong()&Long.MAX_VALUE);
		commands=commands_;
		dims=dims_.clone();
		density=density_;
		density1=density1_;
		edgeBlockSize=edgeBlockSize_;
		layers=dims.length;
		values=makeFloatMatrix(dims);
		eOverNet=makeFloatMatrix(dims);
		
		int cells=(int) shared.Vector.sum(dims);
		list=new ArrayList<Cell>(cells+1);
		transposeCounter=new int[cells+1];
		net=makeNodes(dims, list, values, eOverNet);
		finalLayer=net[layers-1];
		layerStart=new int[dims.length];
		layerStart[0]=1;
		for(int i=1; i<layerStart.length; i++) {
			layerStart[i]=layerStart[i-1]+dims[i-1];
		}

//		weights=makeWeightsMatrix();
//		weightsOut=makeWeightsOutMatrix();
	}
	
	void makeWeightMatrices(){
//		assert(check());
		assert(weightsIn==null);
		weightsIn=makeWeightsInMatrix();
		weightsOut=makeWeightsOutMatrix();
		edgesIn=makeEdgesInMatrix();
		edgesOut=makeEdgesOutMatrix();
//		assert(check());
	}
	
	private float[][][] makeWeightsInMatrix(){
		float[][][] x=new float[dims.length][][];
		for(int layer=1; layer<x.length; layer++) {
			Cell[] currentLayer=net[layer];
			float[][] y=x[layer]=new float[currentLayer.length][];
			for(int i=0; i<y.length; i++) {
				y[i]=currentLayer[i].weights;
			}
		}
		return x;
	}
	
	private int[][][] makeEdgesInMatrix(){
		int[][][] x=new int[dims.length][][];
		for(int layer=1; layer<x.length; layer++) {
			Cell[] currentLayer=net[layer];
			int[][] y=x[layer]=new int[currentLayer.length][];
			for(int i=0; i<y.length; i++) {
				y[i]=currentLayer[i].inputs;
			}
		}
		return x;
	}
	
	private float[][][] makeWeightsOutMatrix(){
		float[][][] x=new float[dims.length][][];
		for(int layer=0; layer<x.length-1; layer++) {
			Cell[] current=net[layer];
			Cell[] next=net[layer+1];
			float[][] y=x[layer]=new float[current.length][];
			if(DENSE) {
				for(int i=0; i<y.length; i++) {
					y[i]=new float[next.length];
				}
			}else {
				for(int i=0; i<y.length; i++) {
					assert(current[i].outputs!=null) : layer+", "+i+", "+current[i].id();
					y[i]=new float[current[i].outputs.length];
				}
			}
		}
		return x;
	}
	
	private int[][][] makeEdgesOutMatrix(){
		int[][][] x=new int[dims.length][][];
		for(int layer=0; layer<x.length-1; layer++) {
			Cell[] currentLayer=net[layer];
			int[][] y=x[layer]=new int[currentLayer.length][];
			for(int i=0; i<y.length; i++) {
				y[i]=currentLayer[i].outputs;
			}
		}
		return x;
	}
	
	public void randomize() {
		{
			Random randy=Shared.threadLocalRandom(seed);
			if(DENSE) {
				makeEdgesDense(net, randy, density, density1, edgeBlockSize);
//				check();
			}else {
				makeEdgesSparse(net, randy, density, density1, edgeBlockSize);
//				check();
			}
			makeWeightMatrices();
//			check();
		}
		assert((Function.TYPE_RATES_CUM!=null)==(shared.Vector.sum(Function.TYPE_RATES)>0)) : Arrays.toString(Function.TYPE_RATES);
		if(Function.TYPE_RATES_CUM!=null || Cell.randomTypeRate>0) {
			Random randy=Shared.threadLocalRandom(seed);
			if(Function.TYPE_RATES_CUM!=null) {
				randomizeActivationA(net, list, randy, Function.TYPE_RATES_CUM);
			}else{
				randomizeActivationB(net, list, randy, Cell.randomTypeRate);
			}
		}
	}
	
	static void randomizeActivationA(Cell[][] net, ArrayList<Cell> list, Random randy, float[] cumRate) {
		assert(cumRate!=null && cumRate[cumRate.length-1]==1) : Arrays.toString(cumRate);
		
		for(int layerNum=1; layerNum<net.length-1; layerNum++) {//Only middle layers
			Cell[] layer=net[layerNum];
			for(Cell c : layer) {
//				c.type=randomType(randy, cumRate);
				c.function=Function.randomFunction(randy);
			}
		}
	}
	
	static void randomizeActivationB(Cell[][] net, ArrayList<Cell> list, Random randy, float rate) {
		assert(rate>0);
//		final int types=Cell.TYPES.length;
		final int types=Tools.min(Cell.MAX_TYPE+1, Function.TYPES.length);
//		assert(false) : types;
//		System.err.println("types="+types);
		for(int layerNum=1; layerNum<net.length-1; layerNum++) {//Only middle layers
			Cell[] layer=net[layerNum];
			for(Cell c : layer) {
				if(randy.nextFloat()<rate) {
//					int t=c.type;
//					while(t==c.type) {t=randy.nextInt(types);}
//					c.type=t;
					Function f=c.function;
					while(f==c.function) {f=Function.getFunction(randy.nextInt(types));}
					c.function=f;
				}
			}
		}
	}
	
	private static float[][] makeFloatMatrix(int[] dims){
		//TODO: Note - these can be made 1 longer with a constant of 1 to include bias
		float[][] matrix=new float[dims.length][];
		for(int i=0; i<dims.length; i++) {
			matrix[i]=new float[dims[i]];
		}
		return matrix;
	}
	
	private static Cell[][] makeNodes(int[] dims, ArrayList<Cell> list, float[][] values, float[][] eOverNext){
		final Cell[][] net=new Cell[dims.length][];
		assert(list.isEmpty());
		list.add(null);
//		int prevWidth=-1, width=dims[0], nextWidth;
		int[] layerStart=new int[dims.length];
		for(int i=0, sum=1; i<dims.length; i++) {
			layerStart[i]=sum;
			sum+=dims[i];
		}
		for(int layerNum=0; layerNum<dims.length; layerNum++) {
			final int prevLayerStart=(layerNum==0 ? -1 : layerStart[layerNum-1]);
			final int nextLayerStart=(layerNum>=dims.length-1 ? -1 : layerStart[layerNum+1]);
			final int width=dims[layerNum];
			final int type=(layerNum<dims.length-1) ? Cell.defaultActivationType : Cell.finalLayerType;
			Cell[] layer=net[layerNum]=new Cell[width];
			float[] lvals=values[layerNum];
			float[] eons=eOverNext[layerNum];
			assert(lvals.length==width) : layerNum+", "+lvals.length+", "+width;
			for(int i=0; i<width; i++){
				Cell c=new Cell(list.size(), type, i, layerNum, dims.length-1, 
						prevLayerStart, nextLayerStart, width, lvals, eons);
				layer[i]=c;
				list.add(c);
			}
		}
		return net;
	}
	
	private static final float layerDensity(float density, float density1, int layer, int layers) {
		return layer>=layers+1 ? 1f : (layer==1 && density1>0) ? density1 : density;
	}
	
	//Fully-connected, but weight 0 edges are not used
	private static long makeEdgesDense(Cell[][] net, Random randy, 
			float density, float density1, int edgeBlockSize){
		long numEdges=0;
		for(int layerNum=1; layerNum<net.length; layerNum++) {
			final float layerDensity=layerDensity(density, density1, layerNum, net.length);
			Cell[] layer=net[layerNum], prev=net[layerNum-1];
			final boolean finalLayer=(layerNum==net.length-1);
//			final int minLen=Tools.mid(1, 5, prev.length/3);
			for(Cell c : layer) {
				assert(c.weights==null);
				c.weights=new float[prev.length];
				c.deltas=new float[prev.length];
				c.setBias(randomBias(randy, 0.8f), true);//TODO: 0.8f should be a parameter
				final float[] weights=c.weights;
//				int nonzero=0;
//				for(int attempt=0; attempt<10 && nonzero<minLen; attempt++) {
//					nonzero=0;
//					for(int i=0; i<weights.length; i++) {
//						float w=randomWeight(randy, 0.5f);
//						w=(finalLayer || randy.nextFloat()<=density ? w : 0);
//						weights[i]=w;
//						numEdges+=(w==0 ? 0 : 1);
//						nonzero+=(w==0 ? 0 : 1);
//					}
//				}
				if(finalLayer) {
					for(int i=0; i<weights.length; i++) {
						weights[i]=randomWeight(randy);
						numEdges++;
					}
				}else {
					BitSet bs=pickEdges(weights.length, edgeBlockSize, layerDensity, randy);
//					System.err.println(bs);
					for(int i=bs.nextSetBit(0); i>=0; i=bs.nextSetBit(i+1)) {
						weights[i]=randomWeight(randy);
						numEdges++;
					}
				}
//				assert(false) : Arrays.toString(c.weights);
			}
		}
		return numEdges;
	}
	
	private static long makeEdgesSparse(Cell[][] net, Random randy, 
			float density, float density1, int edgeBlockSize){
		long numEdges=0;
		for(int layerNum=1; layerNum<net.length; layerNum++) {
			final float layerDensity=layerDensity(density, density1, layerNum, net.length);
			Cell[] layer=net[layerNum], prev=net[layerNum-1];
			final boolean finalLayer=(layerNum==net.length-1);
//			final int minLen=Tools.mid(1, 5, prev.length/3);
			for(Cell c : layer) {
				assert(c.weights==null);
				c.setBias(randomBias(randy, 0.8f), true);//TODO: 0.8f should be a parameter
				if(finalLayer) {
					c.inputs=new int[prev.length];
					for(int i=0; i<c.inputs.length; i++) {c.inputs[i]=i;}
				}else{
					BitSet bs=pickEdges(prev.length, edgeBlockSize, layerDensity, randy);
//					System.err.println(bs);
					c.inputs=toArray(bs);
				}
				c.weights=new float[c.inputs.length];
				c.deltas=new float[c.inputs.length];
				for(int i=0; i<c.weights.length; i++) {
					c.weights[i]=randomWeight(randy);
				}
				numEdges+=(c.weights.length);
			}
		}
		makeOutputSets(net);
		return numEdges;
	}
	
	private static BitSet pickEdges(int width, int edgeBlockSize, float density, Random randy) {
		int toMake=0;
		int min=Tools.mid(1, 5, width/3);
		for(int i=0; i<width; i++) {
			if(randy.nextFloat()<=density) {toMake++;}
		}
		toMake=Tools.max(toMake, min);
		int mod=toMake%edgeBlockSize;
		if(mod!=0) {toMake=Tools.min(width, toMake-mod+edgeBlockSize);}
		BitSet bs=new BitSet(width);
		int range=(width-1)/edgeBlockSize;
		for(int made=0; made<toMake;) {
			int start=randy.nextInt(range+1)*edgeBlockSize;
			if(start<width && !bs.get(start)) {
				for(int i=0; i<edgeBlockSize && i+start<width; i++) {
					bs.set(i+start);
					made++;
				}
			}
		}
//		System.err.println(bs);
		return bs;
	}
	
	static int[] toArray(BitSet bs) {
		int[] array=new int[bs.cardinality()];
		for(int i=bs.nextSetBit(0), j=0; i>=0; i=bs.nextSetBit(i+1), j++) {
			array[j]=i;
		}
		return array;
	}
	
	static void makeOutputSets(Cell[][] net) {
		final int cells;
		{
			Cell[] lastLayer=net[net.length-1];
			Cell c=lastLayer[lastLayer.length-1];
			cells=c.id();
		}
		IntList[] map=new IntList[cells+1];
		for(int lnum=0; lnum<net.length-1; lnum++) {
			for(Cell c : net[lnum]) {
				assert((c.inputs!=null || c.layer==0) && c.outputs==null);
				map[c.id()]=new IntList();
			}
		}
		for(int lnum=1; lnum<net.length; lnum++) {
			for(Cell c : net[lnum]) {
				for(int i : c.inputs) {
					map[i+c.prevLayerStart].add(c.lpos);
				}
			}
		}
		for(int lnum=0; lnum<net.length-1; lnum++) {
			for(Cell c : net[lnum]) {
				c.outputs=map[c.id()].toArray();
//				System.err.println("c"+c.id()+" outputs="+c.outputs.length);
			}
		}
	}
	
	private static float randomBias(Random randy, float probFlat) {
		float weight=0;
		while(Math.abs(weight)<=Float.MIN_NORMAL) {
			if(randy.nextFloat()<=probFlat){
				weight=(1-2*randy.nextFloat())*.25f;
			}else{
				weight=randy.nextFloat()*randy.nextFloat()*randy.nextFloat()*2*(randy.nextBoolean() ? 1 : -1);
			}
		}
		return weight;
	}
	
	//Distributed between -2 and 2.  probFlat=1 gives a uniform distribution from -1 to 1; 0 gives quadratic.
	private static float randomWeight(Random randy) {
		float weight=0;
		while(Math.abs(weight)<=Float.MIN_NORMAL) {
			final float f=randy.nextFloat();
			if(f<=PROB_FLAT){
				weight=(1-2*randy.nextFloat())*.25f;
			}else if(f<=PROB_FLAT+PROB_EXP){
				weight=(float)(Tools.exponential(randy, EXP_LAMDA)*(randy.nextBoolean() ? 1f : -1f));
			}else{
				weight=randy.nextFloat()*randy.nextFloat()*randy.nextFloat()*2*(randy.nextBoolean() ? 1f : -1f);
			}
		}
		weight=Tools.mid(-RAND_WEIGHT_CAP, weight, RAND_WEIGHT_CAP);
		return weight;
	}
	
	/*--------------------------------------------------------------*/
	/*----------------           Methods            ----------------*/
	/*--------------------------------------------------------------*/
	
	
	void anneal(float strength, Random randy) {
		//assert(check());
		for(Cell c : list) {
			if(c!=null) {c.anneal(strength, randy);}
		}
		
		//assert(check());
	}
	
	public void processSample(Sample s, boolean backProp, float weightMult) {
		//assert(check());
		
		applyInput(s.in);
		if(DENSE) {
			feedForwardDense();
		}else {
			feedForwardSparse();
		}

//		s.errorValue=0;
		for(int i=0; i<finalLayer.length; i++) {
			s.result[i]=finalLayer[i].value();
//			s.errorValue+=(s.result[i]-s.goal[i]);
		}
		
		s.calcError(weightMult);
		
		if(!backProp) {return;}
		
//		double error=calcError(s.goal);
//		assert(error==s.errorMagnitude) : "\n"+s.result[0]+", "+s.goal[0]+", "+s.errorMagnitude+"\n"
//				+ finalLayer[0].value()+", "+s.goal[0]+", "+error+"\n";
		
//		s.errorMagnitude=(float)error;
//		s.weightedErrorMagnitude=(float)error*Cell.getWeightMultiplier(s.result[0], s.goal[0]);
		
//		errorSum+=s.errorMagnitude;
//		weightedErrorSum+=s.weightedErrorMagnitude;
		if(DENSE) {
			backPropDense(s.goal, weightMult);
		}else {
			backPropSparse(s.goal, weightMult);
		}
		//assert(check());
	}
	
	public void applyInput(FloatList valuesIn) {
		//assert(check());
		assert(valuesIn.size==dims[0]) : valuesIn.size+"; "+Arrays.toString(dims);
		Vector.copy(values[0], valuesIn.array);
		return;
	}
	
	public void applyInput(float[] valuesIn) {
		//assert(check());
		assert(valuesIn.length==dims[0]) : valuesIn.length+"; "+Arrays.toString(dims);
		Vector.copy(values[0], valuesIn);
		return;
	}
	
	public float feedForward() {
		return (CellNet.DENSE ? feedForwardDense() : feedForwardSparse());
	}
	
	public float feedForwardSparse(){
		//assert(check());
		for(int lnum=1; lnum<layers; lnum++){
			final float[] valuesIn=values[lnum-1];
			Cell[] layer=net[lnum];
			for(int cnum=0; cnum<layer.length; cnum++) {
				Cell c=layer[cnum];
				//				//assert(c.check());
				c.summateSparse(valuesIn, edgeBlockSize);
				//				//assert(c.check());
			}
		}
		return finalLayer[0].value();
	}
	
	public float feedForwardDense(){
		//assert(check());
		for(int lnum=1; lnum<layers; lnum++){
			final float[] valuesIn=values[lnum-1];
			Cell[] layer=net[lnum];
			if(SPECIAL_FMA) {
				Vector.feedForwardDense(layer, valuesIn);
			}else {
				for(int cnum=0; cnum<layer.length; cnum++) {
					Cell c=layer[cnum];
					//				//assert(c.check());
					c.summateDense(valuesIn);
					//				//assert(c.check());
				}
			}
		}
		return finalLayer[0].value();
	}
	
	public void backPropSparse(float[] truth, float weightMult) {
		//assert(check());
		{
			final float[] valuesIn=values[values.length-2];
			for(int i=0; i<finalLayer.length; i++) {
				final Cell c=finalLayer[i];
				//Final layer is always dense
				c.updateEdgesFinalLayerDense(truth[i], valuesIn, weightMult);
			}
		}
		
		for(int lnum=layers-2; lnum>0; lnum--) {
			final float[] valuesIn=values[lnum-1];
			final float[] eOverNetNext=eOverNet[lnum+1];
			Cell[] layer=net[lnum];
			float[][] weightsOutLnum=weightsOut[lnum];
			
			for(int i=0; i<layer.length; i++){
				Cell c=layer[i];
				//assert(c.check());
				c.updateEdgesHiddenLayerSparse(valuesIn, eOverNetNext, weightsOutLnum[i], edgeBlockSize);
				//assert(c.check());
			}
		}
		//assert(check());
	}
	
	public void backPropDense(float[] truth, float weightMult) {
		//assert(check());
		{
			final float[] valuesIn=values[values.length-2];
			for(int i=0; i<finalLayer.length; i++) {
				final Cell c=finalLayer[i];
				//assert(c.check());
				c.updateEdgesFinalLayerDense(truth[i], valuesIn, weightMult);
				//assert(c.check());
			}
		}
		
		for(int lnum=layers-2; lnum>0; lnum--) {
			final float[] valuesIn=values[lnum-1];
			final float[] eOverNetNext=eOverNet[lnum+1];
			Cell[] layer=net[lnum];
			float[][] weightsOutLnum=weightsOut[lnum];
			
			if(SPECIAL_FMA) {Vector.backPropFma(layer, eOverNetNext, weightsOutLnum);}
			for(int i=0; i<layer.length; i++){
				Cell c=layer[i];
				//assert(c.check());
				c.updateEdgesHiddenLayerDense(valuesIn, eOverNetNext, weightsOutLnum[i]);
				//assert(c.check());
			}
		}
		//assert(check());
	}
	
	void transpose() {
		if(DENSE) {transposeDense();}
		else {transposeSparse();}
	}
	
	void transposeDense() {
		for(int layer=0; layer<weightsIn.length-1; layer++) {
			float[][] weightsInL=weightsIn[layer+1], weightsOutL=weightsOut[layer];
			for(int lnum=0; lnum<weightsOutL.length; lnum++) {
				float[] weightsOutC=weightsOutL[lnum];
				for(int lnumOut=0; lnumOut<weightsInL.length; lnumOut++) {
					weightsOutC[lnumOut]=weightsInL[lnumOut][lnum];
				}
			}
		}
	}
	
	void transposeSparse() {
		Arrays.fill(transposeCounter, 0);
		for(int layer=0; layer<weightsIn.length-1; layer++) {
			float[][] weightsInL=weightsIn[layer+1], weightsOutL=weightsOut[layer];
			int[][] edgesOutL=edgesOut[layer];
			for(int lnum=0; lnum<weightsOutL.length; lnum++) {
				float[] weightsOutC=weightsOutL[lnum];
				int[] outputs=edgesOutL[lnum];
				assert(outputs.length==weightsOutC.length);
				for(int i=0; i<outputs.length; i++) {
					int lnumOut=outputs[i];
					int cidOut=lnumOut+layerStart[layer+1];
//					assert(false) : Arrays.toString(layerStart)+", "+layer+", "+lnumOut+", "+cidOut;
					int inputNum=transposeCounter[cidOut];
					transposeCounter[cidOut]++;
					weightsOutC[i]=weightsInL[lnumOut][inputNum];
				}
			}
		}
		for(Cell c : list) {
			assert(c==null || c.inputs==null || transposeCounter[c.id()]==c.inputs.length);
		}
	}
	
	public void applyChanges(int samples, float alpha) {
		//assert(check());
		float invSamples=1f/samples;
		assert(invSamples<=1) : samples+", "+invSamples;
		for(Cell c : list) {
			if(c!=null) {
				c.applyUpdates(invSamples, alpha);
			}
		}
		//assert(check());
		epochsTrained++;
		samplesTrained+=samples;
	}
	
	public float getOutput(int outnum){
		return net[layers-1][outnum].value();
	}
	
	public float[] getOutput(){
		Cell[] outLayer=net[layers-1];
		float[] out=new float[outLayer.length];
		for(int i=0; i<outLayer.length; i++) {
			out[i]=outLayer[i].value();
		}
		return out;
	}
	
	@Deprecated
	public double calcError(float[] truth){
		double error=0;
		for(int i=0; i<finalLayer.length; i++){
			Cell c=finalLayer[i];
			float t=truth[i];
			float e=c.calcError(t);
			error+=e;
		}
		return error;
	}

	
	/*--------------------------------------------------------------*/
	/*----------------            X            ----------------*/
	/*--------------------------------------------------------------*/
	
	public String toString() {
		StringBuilder sb=new StringBuilder();
		for(int layernum=0; layernum<layers; layernum++) {
			Cell[] layer=net[layernum];
			sb.append("\n* Layer "+layernum+", nodes="+layer.length+" *");
			for(Cell c : layer) {
				sb.append("\n"+c.toString());
			}
		}
		return sb.toString();
	}
	
	public ByteBuilder header() {
		ByteBuilder bb=new ByteBuilder();
		bb.append("##bbnet").nl();
		bb.append("#version ").append(version).nl();
		if(CONCISE) {bb.append("#concise").nl();}
		bb.append(OUT_DENSE ? "#dense" : OUT_SPARSE ? "#sparse" : DENSE ? "#dense" : "#sparse").nl();
		bb.append("#density ").append(density, 8, true).nl();
		if(density1>0 && density1!=density) {bb.append("#density1 ").append(density1, 8, true).nl();}
		bb.append("#blocksize ").append(edgeBlockSize).nl();
		bb.append("#seed ").append(seed).nl();
//		if(annealSeed!=seed) {bb.append("#annealseed ").append(annealSeed).nl();}
		bb.append("#layers ").append(layers).nl();
		if(epochsTrained>0) {bb.append("#epochs ").append(epochsTrained).nl();}
		if(samplesTrained>0) {bb.append("#samples ").append(samplesTrained).nl();}
		
		bb.append("#dims");
		for(int d : dims) {bb.space().append(d);}
		bb.nl();
		for(String s : commands) {bb.append(s).nl();}
		if(lastStats!=null) {bb.append("##stats ").append(lastStats).nl();}
		bb.append("##fpr ").append(fpRate, 6).nl();
		bb.append("##fnr ").append(fnRate, 6).nl();
		bb.append("##err ").append(errorRate, 6).nl();
		bb.append("##wer ").append(weightedErrorRate, 6).nl();
		bb.append("##ctf ").append(cutoff, 6).nl();
		return bb;
	}
	
	public ByteBuilder toBytes() {
		
		ByteBuilder bb=header();
		bb.append("#edges ").append(countEdges()).nl();
		
		lastLinesWritten=18;
		long edgeCount=0;
		assert(CONCISE);
		for(int lnum=1; lnum<layers; lnum++) {
			Cell[] layer=net[lnum];
			Cell[] prev=net[lnum-1];
			bb.append("##layer ").append(lnum).nl();
			for(Cell c : layer){
				if(DENSE) {
					if(OUT_SPARSE) {
						lastLinesWritten+=2;
						
						if(OUT_HEX) {
							bb.append('H').append(c.id()).space();
							BitSet bs=new BitSet(c.weights.length);
							for(int i=0; i<c.weights.length; i++) {
								if(c.weights[i]!=0) {bs.set(i);}
							}
							toHex(bs, bb);
						}else {
							bb.append('I').append(c.id());
							for(int i=0; i<c.weights.length; i++) {
								if(c.weights[i]!=0) {
									bb.space().append(i);
								}
							}
						}
						bb.nl();

						bb.append('W').append(c.id()).space().append(c.typeString());
						bb.space().append(c.bias(), 6, true);
						for(int i=0; i<c.weights.length; i++) {
							if(c.weights[i]!=0) {
								bb.space().append(c.weights[i], 6, true);
								edgeCount++;
							}
						}
						bb.nl();
					}else {
						lastLinesWritten++;
						bb.append('C').append(c.id()).space().append(c.typeString());
						bb.space().append(c.bias(), 6, true);
						for(int i=0; i<c.weights.length; i++) {bb.space().append(c.weights[i], 6, true);}
						bb.nl();
						edgeCount+=c.weights.length;
					}
				}else {
					if(OUT_DENSE) {
						lastLinesWritten++;
						bb.append('C').append(c.id()).space().append(c.typeString());
						bb.space().append(c.bias(), 6, true);
//						for(int idx=0, nextInput=0; idx<c.inputs.length; idx++) {
//							for(int inum=c.inputs[idx]; nextInput<inum; nextInput++) {
//								bb.space().append(0);
//							}
//							bb.space().append(c.weights[idx], 6, true);
//							nextInput++;
//						}
						int inum=0;
						for(int idx=0; idx<c.inputs.length; inum++) {
							if(inum==c.inputs[idx]) {
								bb.space().append(c.weights[idx], 6, true);
								idx++;
							}else {
								bb.space().append(0);
							}
						}
						for(; inum<dims[c.layer-1]; inum++) {bb.space().append(0);}
						bb.nl();
						edgeCount+=c.weights.length;
					}else {
						lastLinesWritten+=2;
						if(OUT_HEX) {
							bb.append('H').append(c.id()).space();
							toHex(c.inputs, bb);
						}else {
							bb.append('I').append(c.id());
							for(int i=0; i<c.inputs.length; i++) {bb.space().append(c.inputs[i]);}
						}
						bb.nl();

						bb.append('W').append(c.id()).space().append(c.typeString());
						bb.space().append(c.bias(), 6, true);
						for(int i=0; i<c.weights.length; i++) {bb.space().append(c.weights[i], 6, true);}
						bb.nl();
						edgeCount+=c.weights.length;
					}
				}
			}
		}
		return bb;
	}
	
	static ByteBuilder toHex(int[] set, ByteBuilder bb) {
		if(set==null || set.length==0) {return bb.append(0);}
		final int max=set[set.length-1];
		BitSet bs=new BitSet(max);
		for(int e : set) {bs.set(e);}
		return toHex(bs, bb);
	}
	
	static ByteBuilder toHex(BitSet bs, ByteBuilder bb) {
		byte[] bytes=bs.toByteArray();
		for(byte b : bytes) {
			bb.append((byte)('0'+(b&15)));
			bb.append((byte)('0'+((b>>4)&15)));
		}
		return bb;
	}
	
	static int[] fromHex(byte[] line, int start) {
		byte[] bytes=new byte[(line.length-start)/2];
		for(int i=start, j=0; i<line.length; i+=2, j++) {
			byte a=line[i], b=line[i+1];
			int x=((a-'0')&15)|(((b-'0')&15)<<4);
			bytes[j]=(byte)x;
		}
		BitSet bs=BitSet.valueOf(bytes);
		return toArray(bs);
	}
	
	public synchronized CellNet copy(boolean copyDelta) {
//		assert(check());
		CellNet copy=new CellNet(dims, seed, density, density1, edgeBlockSize, commands);
		ArrayList<Cell> list2=copy.list;
		for(int i=1; i<list.size(); i++) {
			Cell c=list.get(i);
//			assert(c.check());
			Cell c2=list2.get(i);
			c2.setFrom(c, copyDelta);
//			System.err.println("Checking "+c.id()+": copyDelta="+copyDelta+", "+c.weights+", "+c.outputs
//					+", "+c2.weights+", "+c2.outputs);
//			assert(c2.check());
		}
		copy.makeWeightMatrices();
//		assert(copy.check());
		copy.commands=commands;
		copy.errorRate=errorRate;
		copy.weightedErrorRate=weightedErrorRate;
		copy.fpRate=fpRate;
		copy.fnRate=fnRate;
		copy.tpRate=tpRate;
		copy.tnRate=tnRate;
		copy.cutoff=cutoff;
		copy.alpha=alpha;
		copy.annealStrength=annealStrength;
//		copy.annealSeed=annealSeed;
		copy.epoch=epoch;
		copy.epochsTrained=epochsTrained;
		copy.lastStats=lastStats;
		copy.samplesTrained=samplesTrained;
		
//		assert(copy.check());
		return copy;
	}
	
	public CellNet setFrom(CellNet cn, boolean copyWeight2) {
		//assert(cn.check());
		//assert(check());
		ArrayList<Cell> list2=cn.list;
		for(int i=1; i<list.size(); i++) {
			Cell c=list.get(i);
			//assert(c.check());
			Cell c2=list2.get(i);
			c.setFrom(c2, copyWeight2);
		}
		//assert(cn.check());
		//assert(check());
		commands=cn.commands;
		errorRate=cn.errorRate;
		weightedErrorRate=cn.weightedErrorRate;
		fpRate=cn.fpRate;
		fnRate=cn.fnRate;
		tpRate=cn.tpRate;
		tnRate=cn.tnRate;
		cutoff=cn.cutoff;
		alpha=cn.alpha;
		annealStrength=cn.annealStrength;
//		annealSeed=cn.annealSeed;
		epoch=cn.epoch;
		epochsTrained=cn.epochsTrained;
		lastStats=cn.lastStats;
		samplesTrained=cn.samplesTrained;
		return this;
	}
	
	public boolean check() {
		for(int i=1; i<list.size(); i++) {
			Cell c=list.get(i);
			boolean b=c.check();
			if(!b) {return false;}
		}
		return true;
	}
	
	public void addError(CellNet net2) {
//		errorSum+=net2.errorSum;
//		weightedErrorSum+=net2.weightedErrorSum;
		for(int i=1; i<list.size(); i++) {
			Cell c=list.get(i);
			Cell c2=net2.list.get(i);
			c.addError(c2);
		}
	}
	
	public void accumulate(CellNet net2) {
		synchronized(this) {
			synchronized(net2) {
				for(int i=1; i<list.size(); i++) {
					Cell c=list.get(i);
					Cell c2=net2.list.get(i);
//					synchronized(c) {
						c.accumulate(c2);
//					}
				}
			}
		}
	}
	
	synchronized public void clear() {
//		errorSum=0;
//		weightedErrorSum=0;
		for(Cell c : list) {
			if(c!=null) {c.clearTemp();}
		}
	}
	
	/** Counts the total number of network edges via brute force,
	 * for a sparse or dense network. */
	public long countEdges() {
		long sum=0;
		for(float[][] y : weightsIn) {
			if(y!=null) {
				for(float[] z : y) {
					if(z!=null) {
						for(float f : z) {
							sum+=(f==0 ? 0 : 1);
						}
					}
				}
			}
		}
		return sum;
	}
	
	@Override
	public int compareTo(CellNet b) {
		if(b==null) {
			return 1;
		}else if(compareCode==compareWER && weightedErrorRate!=b.weightedErrorRate) {
			return weightedErrorRate<b.weightedErrorRate ? 1 : -1;
		}else if(compareCode==compareERR && errorRate!=b.errorRate) {
			return errorRate<b.errorRate ? 1 : -1;
		}else if(compareCode==compareFNR && fnRate!=b.fnRate) {
			return fnRate<b.fnRate ? 1 : -1;
		}else if(compareCode==compareFPR && fpRate!=b.fpRate) {
			return fpRate<b.fpRate ? 1 : -1;
		}
		
		if(weightedErrorRate!=b.weightedErrorRate) {
			return weightedErrorRate<b.weightedErrorRate ? 1 : -1;
		}else if(errorRate!=b.errorRate) {
			return errorRate<b.errorRate ? 1 : -1;
		}else if(fnRate!=b.fnRate) {
			return fnRate<b.fnRate ? 1 : -1;
		}else if(fpRate!=b.fpRate) {
			return fpRate<b.fpRate ? 1 : -1;
		}
		
		return 0;
	}
	
	final float pivot() {
		return compareCode==compareWER ? weightedErrorRate : 
			compareCode==compareERR ? errorRate : 
			compareCode==compareFNR ? fnRate :
			compareCode==compareFPR ? fpRate : weightedErrorRate;
	}
	
	/*--------------------------------------------------------------*/
	
	public int numLayers(){
		return dims.length;
	}
	
	public int numInputs(){
		return dims[0];
	}
	
	public int numOutputs(){
		return dims[dims.length-1];
	}
	
	public void setCutoff(float f) {
//		System.err.println("Set cutoff from "+cutoff+" to "+f);
		cutoff=f;
	}
	
	/*--------------------------------------------------------------*/
	
	@Override
	public boolean equals(Object b) {
		return epoch==((CellNet)b).epoch;
	}

	@Override
	public int hashCode() {return epoch;}
	
	/*--------------------------------------------------------------*/
	/*----------------            Fields            ----------------*/
	/*--------------------------------------------------------------*/
	
	float errorRate=999, weightedErrorRate=999;
	float fpRate=999, fnRate=999, tpRate=-999, tnRate=-999;
	float alpha=-1, annealStrength=-1;
	public float cutoff=-1;
	int epoch=-1;
	int count=1; //for printing
	
	long epochsTrained=0;
	long samplesTrained=0;
	String lastStats=null;
	
	/*--------------------------------------------------------------*/
	
	final long seed;
	final int layers;
	final int[] dims; //Stores widths of layers
	final float density;
	final float density1;
	final int edgeBlockSize;
	final Cell[][] net;
	final Cell[] finalLayer;
	final ArrayList<Cell> list;
	
	final float[][] values;
	final float[][] eOverNet;
	/** [layer][lpos][input] */
	float[][][] weightsIn;
	float[][][] weightsOut;
	int[][][] edgesIn;
	int[][][] edgesOut;
	final int[] transposeCounter;//??
	final int[] layerStart;//??
	
	/** 
	 * List of command lines used to produce this network.
	 * As long as the same version is being used this can replicate a network.
	 */
	public ArrayList<String> commands;
	
	long lastLinesWritten=0;
	
	/*--------------------------------------------------------------*/
	
	public static final boolean SPECIAL_FMA=true;//~20% faster when true, but needs ml.Cell class
	public static boolean CONCISE=true;
	public static boolean DENSE=true;
	public static boolean OUT_HEX=false;
	public static boolean OUT_DENSE=false;
	public static boolean OUT_SPARSE=false;
	public static boolean verbose=false;
	public static final int version=1;

	public static float PROB_FLAT=0.3f;
	public static float PROB_EXP=0.4f;
	public static float EXP_LAMDA=5f;
	public static float RAND_WEIGHT_CAP=2.0f;
	
	static int compareCode=0;
	final static int compareWER=0, compareERR=1, compareFNR=2, compareFPR=3;
	
	/*--------------------------------------------------------------*/
	
}
