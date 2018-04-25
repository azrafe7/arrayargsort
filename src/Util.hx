package;

class Util 
{
  static public var swapCount = 0;
	inline static public function swap<T>(a:Array<T>, i:Int, j:Int):Void {
		swapCount++;
    var tmp = a[i];
		a[i] = a[j];
		a[j] = tmp;
	}
  
  inline static public function copy<T>(src:Array<T>, dest:Array<T>, count:Int):Void {
    for (i in 0...count) dest[i] = src[i];
  }
  
  inline static public function compare<T>(a:Array<T>, cmp:T -> T -> Int, i:Int, j:Int):Int {
    return cmp(a[i], a[j]);
  }
  
  inline static public function indirectCompare<T>(a:Array<T>, cmp:T -> T -> Int, i:Int, j:Int, indices:Array<Int>):Int {
    return cmp(a[indices[i]], a[indices[j]]);
  }
  
  static public function sortInfo<T>(a:Array<T>, cmp:T -> T -> Int) {
    
    inline function sign(x) {
      return x < 0 ? -1 : x > 0 ? 1 : 0;
    }
    
    var sorted = true;
    var invSorted = true;
    var allSame = true;
    
    var diff = sign(cmp(a[0], a[1]));
    for (i in 1...a.length) {
      diff = sign(cmp(a[i - 1], a[i]));
      
      if (sorted && diff > 0) sorted = false;
      if (invSorted && diff < 0) invSorted = false;
      if (allSame && diff != 0) allSame = false;
      
      if (!sorted && !invSorted && !allSame) break;
    }
    
    return {sorted:sorted, invSorted:invSorted, allSame:allSame};
  }
}