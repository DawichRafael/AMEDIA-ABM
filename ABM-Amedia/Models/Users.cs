using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace ABM_Amedia.Models
{
    [Table("tUsers")]
    public class Users
    {
        [Key]
        [DisplayName("Id")]
        public int cod_usuario { get; set; }

        [DisplayName("Usuario")]
        [Required(ErrorMessage ="Debe colocar un nombre de usuario")]
        public string txt_user { get; set; }
        
        [DisplayName("Contraseña")]
        [Required(ErrorMessage = "Debe colocar una contraseña")]
        [MinLength(5, ErrorMessage = "debe contener minimo 5 caracteres")]
        public string txt_password { get; set; }
        
        [DisplayName("Nombre")]
        [Required(ErrorMessage ="Debe colocar un nombre")]
        public string txt_nombre { get; set; }
        
        [DisplayName("Apellido")]
        [Required(ErrorMessage ="Debe colocar un apellido")]
        public string txt_apellido { get; set; }
        
        [DisplayName("NoDoc")]
        [Required(ErrorMessage = "Debe colocar un nombre de usuario documento")]
        public string nro_doc { get; set; }
        
        [DisplayName("TipoUsuario")]
        [Required(ErrorMessage ="Debe colocar un tipo de usuario")]
        public int cod_rol { get; set; }

        [DisplayName("Activo?")]
        public int sn_activo { get; set; } = -1;

        [NotMapped]
        public virtual Rol Rol { get; set; }

        [NotMapped]
        public string Descripcion { get; set; }

    }
}
