#pragma checksum "D:\Code\amedia\ABM-Amedia\Views\Home\IndexUser.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "91342cd1d8e652640501a00a175fe5cb472f368a"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Home_IndexUser), @"mvc.1.0.view", @"/Views/Home/IndexUser.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "D:\Code\amedia\ABM-Amedia\Views\_ViewImports.cshtml"
using ABM_Amedia;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "D:\Code\amedia\ABM-Amedia\Views\_ViewImports.cshtml"
using ABM_Amedia.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"91342cd1d8e652640501a00a175fe5cb472f368a", @"/Views/Home/IndexUser.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"5c133d9009ce6b846a3732889f91ef667b9965fe", @"/Views/_ViewImports.cshtml")]
    public class Views_Home_IndexUser : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<dynamic>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
#nullable restore
#line 1 "D:\Code\amedia\ABM-Amedia\Views\Home\IndexUser.cshtml"
  
    ViewData["Title"] = "User Index Page";

#line default
#line hidden
#nullable disable
            WriteLiteral(@"
<div class=""text-center"">
    <h1 class=""display-4"">Bievenido a AMEDIA ABM</h1>
    <div class=""container"">
        <p>
            Eres un usuario el cual no posee permisos por ende solo podras ver esta ventana, recuerda que puedes
            cambiar tu plan para poder acceder a las opciones de administrador comunicandote con nosotros.
        </p>
    </div>
</div>
");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<dynamic> Html { get; private set; }
    }
}
#pragma warning restore 1591
