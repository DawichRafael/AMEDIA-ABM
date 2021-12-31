using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace ABM_Amedia.Models
{
    [Table("tRol")]
    public class Rol
    {
        [Key]
        public int cod_rol { get; set; }

        [DisplayName("Rol")]
        public string txt_desc { get; set; }
	    public int sn_activo { get; set; }
    }
}
