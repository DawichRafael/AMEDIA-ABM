using ABM_Amedia.DataBase;
using ABM_Amedia.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace ABM_Amedia.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly baseDbContext _context;


        public HomeController(ILogger<HomeController> logger, baseDbContext context)
        {
            _logger = logger;
            _context = context;
        }

        public IActionResult Index()
        {
            TempData["name"] = null;
            return View();
        }


        public IActionResult IndexUser(Users user)
        {
            TempData["name"] = user.txt_user;
            return View(user);
        }
        public IActionResult Login()
        {
            return View();
        }

        public IActionResult Logout()
        {
            return View();
        }
        [HttpPost]
        public IActionResult Login([Bind]Users user)
        {
            var CheckUser = _context.User.SingleOrDefault(x => x.txt_user == user.txt_user && x.txt_password == user.txt_password);

            if (CheckUser == null)
            {
                TempData["message"] = "Haz ingresado un dato erroneo, favor verificar";
                return View();
            }

            if (CheckUser.cod_rol == 1)
            {
                TempData["name"] = CheckUser.txt_user;
                return RedirectToAction("Index","User");
            }

            TempData["name"] = CheckUser.txt_user;
            return RedirectToAction("IndexUser");
          }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View();
        }
    }
}
