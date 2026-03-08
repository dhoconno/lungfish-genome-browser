package shared;

import jdk.incubator.vector.ByteVector;
import jdk.incubator.vector.DoubleVector;
import jdk.incubator.vector.FloatVector;
import jdk.incubator.vector.IntVector;
import jdk.incubator.vector.LongVector;
import jdk.incubator.vector.ShortVector;
import jdk.incubator.vector.VectorMask;
import jdk.incubator.vector.VectorOperators;
import jdk.incubator.vector.VectorSpecies;
import ml.Cell;

/** 
 * Holds SIMD methods.
 * @author Brian Bushnell
 * @date Sep 12, 2013
 *
 */
final class SIMD {
	
	//Example from https://medium.com/@Styp/java-18-vector-api-do-we-get-free-speed-up-c4510eda50d2
	@SuppressWarnings("restriction")
	private static final VectorSpecies<Float> FSPECIES=FloatVector.SPECIES_256;//FloatVector.SPECIES_PREFERRED; //This needs to be final or performance drops.
	private static final int FWIDTH=FSPECIES.length();
//	private static final int boundMask=~(FWIDTH-1);
	
	@SuppressWarnings("restriction")
	private static final VectorSpecies<Byte> BSPECIES=ByteVector.SPECIES_256;
	private static final int BWIDTH=BSPECIES.length();
	
	@SuppressWarnings("restriction")
	private static final VectorSpecies<Integer> ISPECIES=IntVector.SPECIES_256;
	private static final int IWIDTH=ISPECIES.length();
	
	@SuppressWarnings("restriction")
	private static final VectorSpecies<Short> SSPECIES=ShortVector.SPECIES_256;
	private static final int SWIDTH=SSPECIES.length();
	
	@SuppressWarnings("restriction")
	private static final VectorSpecies<Double> DSPECIES=DoubleVector.SPECIES_256;
	private static final int DWIDTH=DSPECIES.length();
	
	@SuppressWarnings("restriction")
	private static final VectorSpecies<Long> LSPECIES=LongVector.SPECIES_256;
	private static final int LWIDTH=LSPECIES.length();
	
	@SuppressWarnings("restriction")
	/** 
	 * Vectorized version of "c+=a[i]*b[i]" where a and b are equal-length arrays.
	 * @param a A vector to multiply.
	 * @param b A vector to multiply.
	 * @return Sum of products of vector elements.
	 */
	static final float fma(final float[] a, final float[] b){
		assert(a.length==b.length);
		
		//Note: FSPECIES=FloatVector.SPECIES_256 and FWIDTH=8
		final int limit=FSPECIES.loopBound(a.length);

		FloatVector sum=FloatVector.zero(FSPECIES);
		int i=0;
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
			FloatVector vb=FloatVector.fromArray(FSPECIES, b, i);
			sum=va.fma(vb, sum);
		}
		float c=sum.reduceLanes(VectorOperators.ADD);
		for (; i<a.length; i++) {//Residual scalar loop
			c+=a[i]*b[i];
		}
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Vectorized version of "c+=a[i]*b[bSet[i]]" where a and bSet are equal-length arrays,
	 * and bSet stores indices of b, in ascending contiguous blocks of 8.
	 * @param a A vector to multiply.
	 * @param b A vector to multiply.
	 * @return Sum of products of vector elements.
	 */
	static final float fmaSparse(final float[] a, final float[] b, int[] bSet){
		assert(a.length==bSet.length);
		assert(a.length<b.length);//Otherwise should do normal fma
		
		//Note: FSPECIES=FloatVector.SPECIES_256 and FWIDTH=8
		final int limit=FSPECIES.loopBound(bSet.length);
//		assert(FWIDTH==8);
//		int elements=0;
		
		FloatVector sum=FloatVector.zero(FSPECIES);
		int i=0;
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			int idx=bSet[i];
//			elements+=FWIDTH;
//			assert(idx%8==0) : idx+", "+i+", "+Arrays.toString(bSet);
//			assert(bSet[i+1]==idx+1);
//			assert(bSet[i+7]==idx+7);
			FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
			FloatVector vb=FloatVector.fromArray(FSPECIES, b, idx);
			sum=va.fma(vb, sum);
		}
		float c=sum.reduceLanes(VectorOperators.ADD);
		for (; i<bSet.length; i++) {//Residual scalar loop
//			elements++;
			c+=a[i]*b[bSet[i]];
		}
		
//		float c2=0;
//		for (int j=0; j<bSet.length; j++) {//Verification loop
//			c2+=a[j]*b[bSet[j]];
//		}
//		assert(Tools.absdif(c, c2)<0.0001f) : c+", "+c2;
//		assert(elements==bSet.length);
		
		return c;
	}
	
	/** 
	 * This is here to keep all the vector operations in a single loop,
	 * to prevent going in and out of SIMD mode too often...  hopefully.
	 * ~20% measured speed increase compared to calling fma() for ScoreSequence.
	 */
	@SuppressWarnings("restriction")
	public static void feedForward(final Cell[] layer, final float[] b) {
		assert(false) : "This was giving incorrect results for nets made made with simd=f and vice versa.  Needs validation.";
		final int limit=FSPECIES.loopBound(b.length);
		
		for(int cnum=0; cnum<layer.length; cnum++) {
			final Cell cell=layer[cnum];
			final float[] a=cell.weights;
			FloatVector sum=FloatVector.zero(FSPECIES);
			for(int i=0; i<limit; i+=FWIDTH) {//SIMD loop
				FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
				FloatVector vb=FloatVector.fromArray(FSPECIES, b, i);
				sum=va.fma(vb, sum);
			}
			cell.sum=sum.reduceLanes(VectorOperators.ADD);
		}
		
		for(int cnum=0; cnum<layer.length; cnum++) {
			final Cell cell=layer[cnum];
			final float[] a=cell.weights;
			float residual=cell.bias;
			for (int i=limit+FWIDTH; i<a.length; i++) {//Residual scalar loop
				residual+=a[i]*b[i];
			}
			cell.sum+=residual;
			final float v=(float)cell.activation(cell.sum);
			cell.setValue(v);
		}
	}
	
	/** 
	 * This is here to keep all the vector operations in a single loop,
	 * to prevent going in and out of SIMD mode too often...  hopefully.
	 * ~20% measured speed increase compared to calling fma() for Train. 
	 */
	public static void backPropFma(Cell[] layer, float[] a, float[][] bb) {
		final int limit=FSPECIES.loopBound(a.length);
		
		for(int cnum=0; cnum<layer.length; cnum++) {
			Cell cell=layer[cnum];
			float[] b=bb[cnum];
			FloatVector sum=FloatVector.zero(FSPECIES);
			for(int i=0; i<limit; i+=FWIDTH) {//SIMD loop
				FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
				FloatVector vb=FloatVector.fromArray(FSPECIES, b, i);
				sum=va.fma(vb, sum);
			}
			cell.eTotalOverOut=sum.reduceLanes(VectorOperators.ADD);
		}
		
		if(limit+FWIDTH>=a.length) {return;}//Shortcut when length is divisible by 8.
		
		for(int cnum=0; cnum<layer.length; cnum++) {
			Cell cell=layer[cnum];
			float[] b=bb[cnum];
			float residual=0;
			for (int i=limit+FWIDTH; i<a.length; i++) {//Residual scalar loop
				residual+=a[i]*b[i];
			}
			cell.eTotalOverOut+=residual;
		}
	}
	
	/** 
	 * Performs "a+=incr" where a and incr are equal-length arrays.
	 * @param a A vector to increment.
	 * @param b Increment amount.
	 */
	@SuppressWarnings("restriction")
	static final void add(final float[] a, final float[] b){
		//final int width=SPECIES.length();
		final int limit=FSPECIES.loopBound(a.length);
//		final int limit=a.length&boundMask;
		
		int i=0;
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
			FloatVector vb=FloatVector.fromArray(FSPECIES, b, i);
			FloatVector sum=va.add(vb);
			sum.intoArray(a, i);
		}
		for (; i<a.length; i++) {//Residual scalar loop; TODO: replace with vector mask
			a[i]+=b[i];
		}
	}

	/** 
	 * Performs "a+=b*mult" where a and b are equal-length arrays.
	 * @param a A vector to increment.
	 * @param b Increment amount.
	 * @param mult Increment multiplier.
	 */
	@SuppressWarnings("restriction")
	static final void addProduct(final float[] a, final float[] b, final float mult){
		//final int width=SPECIES.length();
		final int limit=FSPECIES.loopBound(a.length);
//		final int limit=a.length&boundMask;
		
		int i=0;
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
			FloatVector vb=FloatVector.fromArray(FSPECIES, b, i);
			FloatVector sum=va.add(vb.mul(mult));
			sum.intoArray(a, i);
		}
		for (; i<a.length; i++) {//Residual scalar loop; TODO: replace with vector mask
			a[i]+=b[i]*mult;
		}
	}
	
	@SuppressWarnings("restriction")
	static final void addProductSparse(final float[] a, final float[] b, final int[] bSet, final float mult){
		//final int width=SPECIES.length();
		final int limit=FSPECIES.loopBound(bSet.length);
//		final int limit=a.length&boundMask;
		
		int i=0;
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			int idx=bSet[i];
			FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
			FloatVector vb=FloatVector.fromArray(FSPECIES, b, idx);
			FloatVector sum=va.add(vb.mul(mult));
			sum.intoArray(a, i);
		}
		for (; i<bSet.length; i++) {//Residual scalar loop; TODO: replace with vector mask
			a[i]+=b[bSet[i]]*mult;
		}
	}
	
	//a is dest
	@SuppressWarnings("restriction")
	static final void copy(final float[] a, final float[] b){
		final int length=Tools.min(a.length, b.length);
		//final int width=SPECIES.length();
		final int limit=FSPECIES.loopBound(length);
//		final int limit=a.length&boundMask;
		
		int i=0;
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			FloatVector vb=FloatVector.fromArray(FSPECIES, b, i);
			vb.intoArray(a, i);
		}
		for (; i<length; i++) {//Residual scalar loop; TODO: replace with vector mask
			a[i]=b[i];
		}
	}
	
	/** Returns number of matches */
	@SuppressWarnings("restriction")
	static final int countMatches(final byte[] s1, final byte[] s2, int a1, int b1, int a2, int b2){
		final int length=b2-a2+1;
		final int limit0=BSPECIES.loopBound(length);
		final int limit=a2+limit0;
		
		int i=a1, j=a2;
		int matches=0;
		for(; j<limit; i+=BWIDTH, j+=BWIDTH) {//SIMD loop
			ByteVector v1=ByteVector.fromArray(BSPECIES, s1, i);
			ByteVector v2=ByteVector.fromArray(BSPECIES, s2, j);
			VectorMask<Byte> x=v1.eq(v2);
			matches+=x.trueCount();//This might be slow, or might not
		}
		for(; j<=b2; i++, j++) {
			final byte x=s1[i], y=s2[j];
			final int m=((x==y) ? 1 : 0);
			matches+=m;
		}
		return matches;
	}
	
	/** Returns index of symbol */
	@SuppressWarnings("restriction")
	static final int find(final byte[] a, final byte symbol, final int from, final int to){//15% Slower than scalar code, at least for ByteFile1
		final int length=to-from;//Intentionally exclusive
		final int limit0=BSPECIES.loopBound(length);
		final int limit=from+limit0;
		
		int pos=from;
		for(; pos<limit; pos+=BWIDTH) {//SIMD loop
			ByteVector v=ByteVector.fromArray(BSPECIES, a, pos);
			VectorMask<Byte> x=v.eq(symbol);
			int t=x.firstTrue();
			if(t<BWIDTH) {return pos+t;}
//			if(x.anyTrue()) {break;}
		}
		while(pos<to && a[pos]!=symbol){pos++;}
		return pos;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Sums the array.
	 * @param a A vector.
	 * @return The sum.
	 */
	static final float sum(final float[] a, final int from, final int to){
		final int length=to-from+1;//Intentionally inclusive
		final int limit0=FSPECIES.loopBound(length);
		final int limit=from+limit0;

		FloatVector sum=FloatVector.zero(FSPECIES);
		int i=from;
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
			sum=sum.add(va);
		}
		float c=sum.reduceLanes(VectorOperators.ADD);
		for (; i<=to; i++) {c+=a[i];}//Residual scalar loop
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Sums the array.
	 * @param a A vector.
	 * @return The sum.
	 */
	static final long sum(final long[] a, final int from, final int to){
		final int length=to-from+1;
		final int limit0=LSPECIES.loopBound(length);
		final int limit=from+limit0;

		LongVector sum=LongVector.zero(LSPECIES);
		int i=from;
		for(; i<limit; i+=LWIDTH) {//SIMD loop
			LongVector va=LongVector.fromArray(LSPECIES, a, i);
			sum=sum.add(va);
		}
		long c=sum.reduceLanes(VectorOperators.ADD);
		for (; i<=to; i++) {c+=a[i];}//Residual scalar loop
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Sums the array.
	 * @param a A vector.
	 * @return The sum.
	 */
	static final long sum(final int[] a, final int from, final int to){//Tested as 1.5x scalar speed
		final int length=to-from+1;
		final int limit0=ISPECIES.loopBound(length);
		final int limit=from+limit0;
		
		int i=from;
		long c=0;
		for(; i<limit; i+=IWIDTH) {//SIMD loop
			IntVector va=IntVector.fromArray(ISPECIES, a, i);
			c+=va.reduceLanesToLong(VectorOperators.ADD);//This is probably slow
		}
		for (; i<=to; i++) {c+=a[i];}//Residual scalar loop
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Sums the array.
	 * @param a A vector.
	 * @return The sum.
	 */
	static final long sum(final byte[] a, final int from, final int to){//Tested as 4x scalar speed
		//TODO: Test speed.
		final int length=to-from+1;
		final int limit0=BSPECIES.loopBound(length);
		final int limit=from+limit0;
		
		int i=from;
		long c=0;
		for(; i<limit; i+=BWIDTH) {//SIMD loop
			ByteVector va=ByteVector.fromArray(BSPECIES, a, i);
			c+=va.reduceLanesToLong(VectorOperators.ADD);
		}
		for (; i<=to; i++) {c+=a[i];}//Residual scalar loop
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Sums the array.
	 * @param a A vector.
	 * @return The sum.
	 */
	static final double sum(final double[] a, final int from, final int to){
		final int length=to-from+1;
		final int limit0=DSPECIES.loopBound(length);
		final int limit=from+limit0;

		DoubleVector sum=DoubleVector.zero(DSPECIES);
		int i=from;
		for(; i<limit; i+=DWIDTH) {//SIMD loop
			DoubleVector va=DoubleVector.fromArray(DSPECIES, a, i);
			sum=sum.add(va);
		}
		double c=sum.reduceLanes(VectorOperators.ADD);
		for (; i<=to; i++) {c+=a[i];}//Residual scalar loop
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Finds the maximum value.
	 * @param a A vector.
	 * @return The max.
	 */
	static final int max(final int[] a, final int from, final int to){//Tested as 5x scalar speed
		final int length=to-from+1;
		final int limit0=ISPECIES.loopBound(length);
		final int limit=from+limit0;
		
		int i=from;
		IntVector max=IntVector.broadcast(ISPECIES, a[from]);
		for(; i<limit; i+=IWIDTH) {//SIMD loop
			IntVector va=IntVector.fromArray(ISPECIES, a, i);
			max=max.max(va);
		}
		int c=max.reduceLanes(VectorOperators.MAX);
		for (; i<=to; i++) {//Residual scalar loop
			final int x=a[i];
			c=(x>c ? x : c);
		}
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Finds the maximum value.
	 * @param a A vector.
	 * @return The max.
	 */
	static final long max(final long[] a, final int from, final int to){
		final int length=to-from+1;
		final int limit0=LSPECIES.loopBound(length);
		final int limit=from+limit0;
		
		int i=from;
		LongVector max=LongVector.broadcast(LSPECIES, a[from]);
		for(; i<limit; i+=LWIDTH) {//SIMD loop
			LongVector va=LongVector.fromArray(LSPECIES, a, i);
			max=max.max(va);
		}
		long c=max.reduceLanes(VectorOperators.MAX);
		for (; i<=to; i++) {//Residual scalar loop
			final long x=a[i];
			c=(x>c ? x : c);
		}
		return c;
	}
	
	@SuppressWarnings("restriction")
	/** 
	 * Finds the maximum value.
	 * @param a A vector.
	 * @return The max.
	 */
	static final float max(final float[] a, final int from, final int to){
		final int length=to-from+1;
		final int limit0=FSPECIES.loopBound(length);
		final int limit=from+limit0;
		
		int i=from;
		FloatVector max=FloatVector.broadcast(FSPECIES, a[from]);
		for(; i<limit; i+=FWIDTH) {//SIMD loop
			FloatVector va=FloatVector.fromArray(FSPECIES, a, i);
			max=max.max(va);
		}
		float c=max.reduceLanes(VectorOperators.MAX);
		for (; i<=to; i++) {//Residual scalar loop
			final float x=a[i];
			c=(x>c ? x : c);
		}
		return c;
	}
	
	
}
