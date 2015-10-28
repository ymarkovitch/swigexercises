/*-*- tab-width: 2; indent-tabs-mode: nil -*-*/
/*******************************************************************************
 FILE         :   swigtests_assembly_info.cs
 DESCRIPTION  :   The assembly info for SWIG tests

 PROGRAMMED BY:   Yakov Markovitch
 CREATION DATE:   28 Oct 2015
*******************************************************************************/
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Security.Permissions;
using System.Runtime.InteropServices;

#region General attributes

[assembly: AssemblyCompany("Yakov Markovitch")]
[assembly: AssemblyProduct("SWIG Exercises")]
[assembly: AssemblyCopyright("\u00A9 2015 Yakov Markovitch. All rights reserved.")]
[assembly: AssemblyTitle("SWIG C# Exercises")]
[assembly: AssemblyDescription("Exercises in making advanced SWIG wrappers for C#")]
#if DEBUG
    #if TRACE
    [assembly: AssemblyConfiguration("Debug with tracing")]
    #else
    [assembly: AssemblyConfiguration("Debug")]
    #endif
#else
    #if TRACE
    [assembly: AssemblyConfiguration("Release with tracing")]
    #else
    [assembly: AssemblyConfiguration("Release")]
    #endif
#endif

[assembly: AssemblyCulture("")]

#endregion General attributes

#region Build-specific attributes, should be specified for every build

[assembly: AssemblyVersion("0.0.1")]
[assembly: AssemblyFileVersion("0.0.1.01")]
[assembly: AssemblyInformationalVersion("0.0.1")]

#endregion Build-specific attributes
