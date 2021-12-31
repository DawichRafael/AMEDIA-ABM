using ABM_Amedia.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ABM_Amedia.DataBase
{
    public class baseDbContext : DbContext
    {
        public baseDbContext(DbContextOptions<baseDbContext> db) : base(db)
        {

        }

        public DbSet<Users> User { get; set; }
        public DbSet<Rol> Rol { get; set; }
    }
}
