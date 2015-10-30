/* -*- mode: swig-csharp; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/*******************************************************************************
 FILE         :   swigexercises.swg
 DESCRIPTION  :   Base SWIG definitions for SWIG C# exercises

 PROGRAMMED BY:   Yakov Markovitch
 CREATION DATE:   13 Jul 2015
*******************************************************************************/
%include <pcomn_macros.swg>
%include <pcomn_property.swg>
%include <pcomn_intrusive_ptr.i>

%include <exception.i>
%include <stdint.i>
%include <stl.i>

// Code sections
#define %csimclasscode     %pragma(csharp) imclasscode=
#define %csmoduleclasscode %insert("moduleclass")
#define %csproxyclasscode  %insert("proxyclass")

// Consider the values of particular native enum equal to values
// of corresponding "platform"  (.NET) enum
%define %csnativeenum(cenum, nativeenum)
%apply int {cenum} ;
%typemap(cstype) cenum #nativeenum
%typemap(imtype) cenum #nativeenum
%typemap(ctype)  cenum "int"
%enddef

// We extend all base classes with these members and use them only
// in the wrapper black magic
%csmethodmodifiers _GetSwigProxyHandle "private" ;
%csmethodmodifiers _SetSwigProxyHandle "private" ;
%csmethodmodifiers WrapCopy            "internal" ;
%newobject         WrapCopy ;

%pragma(csharp) imclassclassmodifiers="  [System.Security.SuppressUnmanagedCodeSecurity] class"
%pragma(csharp) moduleclassmodifiers= "public static class"

%pragma(csharp) moduleimports=%{
using System ;
using System.Collections ;
using System.Collections.Generic ;
using System.Runtime ;
using System.Runtime.InteropServices ;
using System.Security ;
using SWIG.Exercises ;
%}

%typemap(csimports) SWIGTYPE, SWIGTYPE *, SWIGTYPE &, SWIGTYPE &&, SWIGTYPE [], SWIGTYPE (CLASS::*) %{
  using System ;
  using System.Runtime ;
  using System.Runtime.InteropServices ;
  using System.Diagnostics ;
  using System.Collections ;
  using System.Collections.Generic ;
  using System.Linq ;

  using ProxyClass  = $csclassname ;
  using ModuleClass = $module ;
%}

%{
#include <pcomn_string.h>

static void SWIG_StdCSharpException()
{
  try { throw ; }

  catch (std::invalid_argument &e) {
    SWIG_CSharpSetPendingExceptionArgument(pcomn::str::startswith(e.what(), "Invalid (NULL) argument")
     ? SWIG_CSharpArgumentNullException
     : SWIG_CSharpArgumentException,
     e.what(), nullptr) ;
  }
  catch (std::domain_error &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpArithmeticException, e.what()) ;
  }
  catch (std::overflow_error &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpOverflowException, e.what()) ;
  }
  catch (std::out_of_range &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpIndexOutOfRangeException, e.what()) ;
  }
  catch (std::length_error &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpIndexOutOfRangeException, e.what()) ;
  }
  catch (std::runtime_error &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpApplicationException, e.what()) ;
  }
  catch (std::bad_cast &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpInvalidCastException, e.what()) ;
  }
  catch (std::bad_alloc &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpOutOfMemoryException, e.what()) ;
  }
  catch (std::exception &e) {
    SWIG_CSharpSetPendingException(SWIG_CSharpSystemException, e.what()) ;
  }
}

%}

/*******************************************************************************
 Language-abstraction macros

 %member_access(member, level)
 %method_private(method_name)
 %typedef_template(typedef_name, template_instance)
*******************************************************************************///
// %member_access(hello, private)
// %member_access(bye, internal)
#define %member_access(member, level)  %csmethodmodifiers member #level

%define %method_private(method_name)
%member_access(method_name, private)
%rename("%(lowercamelcase)s") method_name ;
%enddef

%define %method_internal(method_name)
%member_access(method_name, internal)
%rename("%(lowercamelcase)s") method_name ;
%enddef

%define %typedef_template(typedef_name, ...)
#if #__VA_ARGS__ == ""
#error Second argument required to %typedef_template, please specify template instance
#endif
%inline %{ typedef __VA_ARGS__ typedef_name ; %}
%template(typedef_name) __VA_ARGS__ ;
%enddef

/*******************************************************************************
 %nbaseclass(csharp-name[, c++-name[, csbaseclass]])
 %nclass(csharp-name [, c++-name])

 If c++-name is not specified, use csharp-name prefixed

 Please note that %nbaseclass() explicitly suppresses generation of public
 contstructors for corresponding proxy class
*******************************************************************************/
// %ndecl(class_name)
//
%define %ndecl(class_name)
%nodefaultctor class_name ;
%nodefaultdtor class_name ;
%typemap(csfinalize) class_name         = SWIGNET_INTCLASS ;
%typemap(csdestruct) class_name         = SWIGNET_INTCLASS ;
%typemap(csdestruct_derived) class_name = SWIGNET_INTCLASS ;
%typemap(csinterfaces) class_name       = SWIGNET_INTCLASS ;

class class_name ;

%typemap(csout) class_name = SWIGNET_INTCLASS ;
%typemap(csout) const class_name & = const SWIGNET_INTCLASS & ;
%typemap(csout) class_name &, class_name && = SWIGNET_INTCLASS & ;
%typemap(csout) class_name * = SWIGNET_INTCLASS * ;
%enddef

// %ndeclvalue(class_name)
//
%define %ndeclvalue(class_name)
class class_name ;
%apply SWIGNET_VALUE {class_name} ;
%apply SWIGNET_VALUE * {class_name *} ;
%apply const SWIGNET_VALUE * {const class_name *} ;
%apply SWIGNET_VALUE & {class_name &} ;
%apply const SWIGNET_VALUE & {const class_name &} ;
%enddef


// %nvalue(class_name)
//
%define %__ndeftypename__(name,...)
#if #__VA_ARGS__ == ""
#define __cpp_name_##name name
#else
#define __cpp_name_##name __VA_ARGS__
#endif
%enddef

#define %__ntypename__(name) __cpp_name_##name

%define %nvalue(name, ...)
%__ndeftypename__(name, ##__VA_ARGS__)
%rename(name) %__ntypename__(name) ;
%nodefault    %__ntypename__(name) ;
// We never return pointers to SWIGNET_VALUEs, they are always converted to values;
// but there are constructors that always create objects through the 'new'.
// SWIGNET_VALUE typemaps overcome this calling WrapCopy, but we should take care
// of the originally constructed object and delete it after the WrapCopy call.
%newobject %__ntypename__(name)::%__ntypename__(name) ;
// Apply all the SWIGNET_VALUE typemaps (even if it can be already done through
// a forward %ndeclvalue() call)
%ndeclvalue(%__ntypename__(name)) ;
%extend %__ntypename__(name) {
  %member_access(WrapCopy, internal) ;
  static const %__ntypename__(name) &WrapCopy(ObjectHandle self)
  {
    return *static_cast<%__ntypename__(name) *>(self) ;
  }
  %member_access(eq, private) ;
  static bool eq(const %__ntypename__(name) *lhs, const %__ntypename__(name) *rhs)
  {
    return lhs && rhs && (lhs == rhs || *lhs == *rhs) ;
  }

  %csproxyclasscode {
    public static bool operator==(name lhs, name rhs)
    {
      return eq(lhs, rhs) ;
    }
    public static bool operator!=(name lhs, name rhs)
    {
      return !(lhs == rhs) ;
    }
    public override bool Equals(object rhs)
    {
      return this == (rhs as name) ;
    }
    public override int GetHashCode()
    {
      throw
        new NotSupportedException(String.Format("GetHashCode() is not supported for {0} objects",
                                                GetType().FullName)) ;
    }
  }
}
%enddef

%define %nbaseclass(name, cname, ...)
%__nrclass__(SWIGNET_BASECLASS, 0, name, cname)
#if `__VA_ARGS__` != ""
%typemap(csbase) cname `__VA_ARGS__`
#endif
%enddef

%define %nclass(name,...)
%__nrclass__(SWIGNET_CLASS, 0, name, ##__VA_ARGS__)
%enddef

// _GetProxyHandleFromWrappedObject/_SetProxyHandleIntoWrappedObject
// should NEVER run pending destructors - these functions can be called
// from outside the main thread!
%exception _GetProxyHandleFromWrappedObject %{ $action %}
%exception _SetProxyHandleIntoWrappedObject %{
   try { $action }
   catch (const std::exception &x) { $cleanup ; (void)x ; } %}

%define %__ndefclass__(type, is_published, name, cname)
%csattribute(::cname, Helpers.InternalName, #cname) ;
%nodefault cname ;
#if #type == "SWIGNET_BASECLASS" || #type == "SWIGNET_EVENTDIRECTOR"
%extend cname {
  %member_access(_GetProxyHandleFromWrappedObject, internal) ;
  %member_access(_SetProxyHandleIntoWrappedObject, internal) ;

  static ProxyHandle _GetProxyHandleFromWrappedObject(ObjectHandle self)
  {
    return nrpxy::get_proxy_handle(static_cast<cname *>(self)) ;
  }
  ProxyHandle _SetProxyHandleIntoWrappedObject(ProxyHandle handle)
  {
    return nrpxy::set_proxy_handle(self, handle) ;
  }
}
#endif
%rename(name) cname ;
%apply type { cname, cname *, const cname *, cname &, const cname & } ;
%enddef

%define %__nrclass__(type, is_published, name,...)
#if #__VA_ARGS__ == ""
%__ndefclass__(type, is_published, name, T##name) ;
#else
%__ndefclass__(type, is_published, name, __VA_ARGS__) ;
#endif
%enddef

%define %ndefstr(classname, expr)
%typemap(cscode) classname "  public override string ToString() { return expr ; }"
%enddef

%define %ToString(funcname)
%rename(ToString) funcname ;
%csmethodmodifiers funcname "public override" ;
std::string funcname() const ;
%enddef

/*
 * Exception processing
 */
%exception {
   //npxy::run_pending_destructors() ;
   try { $action }
   catch(std::exception &) { SWIG_StdCSharpException() ; return $null ; }
}
