package;
import haxe.ds.Either;

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

  static public function shuffle<T>(a:Array<T>):Void
  {
    var len = a.length;
    for (i in 0...len - 1) {
      var j = i + Std.random(len - i);
      Util.swap(a, i, j);
    }
  }

  static public function shuffleRange<T>(a:Array<T>, lo:Int, hi:Int):Void
  {
    var len = hi - lo;
    for (i in 0...len - 1) {
      var j = i + Std.random(len - i);
      Util.swap(a, lo + i, lo + j);
    }
  }

  static public function highlightIndices<T>(a:Array<T>, indices:Array<Int>, labelsStringOrArray:OneOf<String, Array<String>>)
  {
    // clean/extend labels to be same length as indices
    var labels:Array<String> = [];
    switch (labelsStringOrArray)
    {
      case Left(s): labels = s.split('');
      case Right(a): labels = a;
      default:
    }

    for (i in 0...indices.length) {
      if (i >= labels.length) labels[i] = '^';
      if (labels[i].length > 1) labels[i] = labels[i].charAt(0);
    }

  #if js
    var str = "";
  #else
    var str = " ";
  #end
    var lengths = [for (i in 0...a.length) 1 + Std.string(a[i]).length];
    lengths.push(4); // after end of array
    for (i in 0...lengths.length) {
      var len = lengths[i];
      var idx = indices.indexOf(i);
      if (idx >= 0) {
        str += labels[idx] + [for (s in 0...len-1) " "].join("");
      } else {
        str += [for (s in 0...len) " "].join("");
      }
    }
    return str;
  }

  // clamp `x` to [`min`...`max`]. (both inclusive)
  static public function iclamp(x:Int, min:Int, max:Int):Int {
    return x < min ? min : x > max ? max : x;
  }

  static public function imin(a:Int, b:Int):Int {
    return a < b ? a : b;
  }

  static public function imax(a:Int, b:Int):Int {
    return a > b ? a : b;
  }

  inline static public function sign(x:Int):Int {
    return x < 0 ? -1 : x > 0 ? 1 : 0;
  }
}

abstract OneOf<A, B>(Either<A, B>) from Either<A, B> to Either<A, B> {
  @:from inline static function fromA<A, B>(a:A):OneOf<A, B> {
    return Left(a);
  }
  @:from inline static function fromB<A, B>(b:B):OneOf<A, B> {
    return Right(b);
  }

  @:to inline function toA():Null<A> return switch(this) {
    case Left(a): a;
    default: null;
  }
  @:to inline function toB():Null<B> return switch(this) {
    case Right(b): b;
    default: null;
  }
}