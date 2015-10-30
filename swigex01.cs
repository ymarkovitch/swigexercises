/*-*- tab-width:4;indent-tabs-mode:nil -*-*/
using System ;
using System.Collections ;
using System.Collections.Generic ;
using System.Runtime ;
using System.Runtime.InteropServices ;
using System.Security ;
//using SWIG.Exercises ;

public struct Foo
{
    public int v ;
    public static explicit operator bool(Foo f) { return f.v != 0 ; }
    public static bool operator !(Foo f) { return !(bool)f ; }
    public static bool operator true(Foo f) { return (bool)f ; }
    public static bool operator false(Foo f) { return !f ; }
}

public class SwigEx01
{
    public static void Main(string[] args)
    {
        var f = new Foo() ;
        f.v = 5 ;
        if (f)
            Console.WriteLine("Hello, World!") ;
        if (!f)
            Console.WriteLine("Bye, Baby!") ;
    }
}
