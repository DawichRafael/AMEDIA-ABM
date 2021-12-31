using ABM_Amedia.DataBase;
using ABM_Amedia.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ABM_Amedia.Controllers
{
    public class UserController : Controller
    {
        private readonly baseDbContext _context;

        public UserController(baseDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            IEnumerable<Users> listUsers = (from user in _context.User
                                            join role in _context.Rol on user.cod_rol equals role.cod_rol
                                            
                                            select new Users
                                            {
                                                cod_usuario = user.cod_usuario,
                                                cod_rol = role.cod_rol,
                                                txt_user = user.txt_user,
                                                txt_password = user.txt_password,
                                                txt_nombre = user.txt_nombre,
                                                txt_apellido = user.txt_apellido,
                                                nro_doc = user.txt_nombre,
                                                sn_activo = user.sn_activo,
                                                Descripcion = role.txt_desc
                                            }).ToList();
            return View(listUsers);
        }

        public IActionResult Create()
        {
            ViewBag.RolId = new SelectList(_context.Rol, "cod_rol", "txt_desc");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]

        public IActionResult Create(Users users)
        {
            if (ModelState.IsValid)
            {
                _context.User.Add(users);
                _context.SaveChanges();
            }
          
            TempData["message"] = "Se ha creado el usuario satisfactoriamente";
            return RedirectToAction("Index");
        }

        public IActionResult Edit(int? id)
        {
            if (id == null) return NotFound();

            var userId = _context.User.Find(id);

            if (userId == null) return NotFound();
            ViewBag.RolId = new SelectList(_context.Rol, "cod_rol", "txt_desc");

            return View(userId);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(Users users)
        {
            if (ModelState.IsValid)
            {
                _context.User.Update(users);
                _context.SaveChanges();
          
                TempData["message"] = "Se ha editado el usuario satisfactoriamente";
                return RedirectToAction("Index");
            }

            return View();
        }


        public IActionResult Delete(int? id)
        {
            if (id == null) return NotFound();

            var userId = _context.User.Find(id);

            if (userId == null) return NotFound();
            ViewBag.RolId = new SelectList(_context.Rol, "cod_rol", "txt_desc");

            return View(userId);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteUser(int cod_usuario)
        {
            var userDelete = _context.User.Find(cod_usuario);

            if (userDelete == null) return NotFound();
    
            _context.User.Remove(userDelete);
            _context.SaveChanges();

            TempData["message"] = "Se ha elimiando el usuario satisfactoriamente";
            return RedirectToAction("Index");
        }
    }
}
