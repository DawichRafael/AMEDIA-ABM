
-- SCRIPT PARA CREAR LA BASE DE DATOS
CREATE DATABASE TestCrud;

-- SCRIPT PARA USAR LA BASE DE DATOS
USE TestCrud;

-- SCRIPT PARA CREAR TABLA DE ROLES
CREATE TABLE tRol
(
	cod_rol INT IDENTITY PRIMARY KEY NOT NULL, 
	txt_desc VARCHAR(500), 
	sn_activo INT
)
GO;

INSERT INTO trol VALUES ( 'Administrador',-1)
INSERT INTO trol VALUES ( 'Cliente', -1)
GO; 

CREATE TABLE tUsers
(
	cod_usuario INT PRIMARY KEY IDENTITY NOT NULL, 
	txt_user VARCHAR(50), 
	txt_password VARCHAR(50),
	txt_nombre VARCHAR(200), 
	txt_apellido VARCHAR(200), 
	nro_doc VARCHAR(50), 
	cod_rol INT NOT NULL, 
	sn_activo INT NOT NULL, 
	CONSTRAINT fk_user_rol FOREIGN KEY (cod_rol) REFERENCES tRol(cod_rol)
)
GO;

INSERT INTO tUsers VALUES ( 'Admin', 'PassAdmin123', 'Administrador', 'Test', '1234321', 1,-1)
INSERT INTO tUsers VALUES ('userTest', 'Test1', 'Ariel', 'ApellidoConA', '12312321', 2, -1)
INSERT INTO tUsers VALUES ('userTest2', 'Test2', 'Bernardo', 'ApellidoConB', '12312322', 2, -1)
INSERT INTO tUsers VALUES ('userTest3', 'Test3', 'Carlos', 'ApellidoConC', '12312323', 2, -1)
GO

CREATE TABLE tPelicula 
(
	cod_pelicula INT PRIMARY KEY IDENTITY NOT NULL, 
	txt_desc VARCHAR(500), 
	cant_disponibles_alquiler INT, 
	cant_disponibles_venta INT,
	precio_alquiler NUMERIC(18,2) , 
	precio_venta NUMERIC(18,2)
)

GO;

INSERT INTO tPelicula VALUES ('Duro de matar III', 3, 0,1.5,5.0)
INSERT INTO tPelicula VALUES ('Todo Poderoso', 2,1,1.5,7.0)
INSERT INTO tPelicula VALUES ('Stranger than fiction', 1,1,1.5,8.0)
INSERT INTO tPelicula VALUES ('OUIJA', 0,2,2.0,20.50)
GO;

CREATE TABLE tGenero (
	cod_genero INT PRIMARY KEY IDENTITY, 
	txt_desc VARCHAR(500) 
)

GO; 

INSERT INTO tGenero VALUES('Acción')
INSERT INTO tGenero VALUES('Comedia')
INSERT INTO tGenero VALUES('Drama')
INSERT INTO tGenero VALUES('Terror')

GO;

CREATE TABLE tGeneroPelicula (
	cod_pelicula INT NOT NULL, 
	cod_genero INT NOT NULL, 
	PRIMARY KEY(cod_pelicula, cod_genero), 
	CONSTRAINT fk_genero_pelicula FOREIGN KEY(cod_pelicula) REFERENCES tpelicula(cod_pelicula), 
	CONSTRAINT fk_pelicula_genero FOREIGN KEY(cod_genero) REFERENCES tGenero(cod_genero)
)

GO;

INSERT INTO tGeneroPelicula VALUES(1,1)
INSERT INTO tGeneroPelicula VALUES(2,2)
INSERT INTO tGeneroPelicula VALUES(3,2)
INSERT INTO tGeneroPelicula VALUES(3,3)
INSERT INTO tGeneroPelicula VALUES(4,4)
GO

SELECT * FROM tGeneroPelicula;

/*Crear una tabla de alquiler de películas y otra de ventas, que te permita registrar
 qué usuario compró/alquiló dicha película, a que precio y en qué momento */

CREATE TABLE AlquilerPelicula (
		IdAlquilerPelicula INT PRIMARY KEY IDENTITY NOT NULL, 
		Cod_Usuario INT NOT NULL, 
		Cod_Pelicula INT NOT NULL, 
		precio_alquiler NUMERIC(18,2),
		EntregoPelicula varchar(1) default 'N',
		Fecha DATETIME default getDate(), 
		CONSTRAINT fk_user_rent_movie FOREIGN KEY (Cod_Usuario) REFERENCES tUsers(Cod_Usuario),
		CONSTRAINT fk_rent_movie FOREIGN KEY (Cod_Pelicula) REFERENCES tPelicula(cod_pelicula),
)

 
CREATE TABLE VenderPelicula (
		IdVentaPelicula INT PRIMARY KEY IDENTITY NOT NULL, 
		Cod_Usuario INT NOT NULL, 
		Cod_Pelicula INT NOT NULL, 
		precio NUMERIC(18,2),
		Fecha DATETIME default getDate(), 
		CONSTRAINT fk_user_buy_movie FOREIGN KEY (Cod_Usuario) REFERENCES tUsers(Cod_Usuario),
		CONSTRAINT fk_buy_movie FOREIGN KEY (Cod_Pelicula) REFERENCES tPelicula(cod_pelicula),
)

 
/*Se necesitan generar Stored Procedures que te permitan:
1) Crear usuarios, cuyo documento no exista actualmente en la base de datos, en
caso de existir, debería devolver un mensaje de error, en caso contrario insertarlo */

-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Crea usuarios con No. Documento 
--				distinto.
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE createUsers
	-- Add the parameters for the stored procedure here
	@userName VARCHAR(50) = NULL, 
		@userPassword VARCHAR(50) = NULL,
		@nombre VARCHAR(200) = NULL, 
		@apellido VARCHAR(200) = NULL, 
		@noDoc VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
    -- Insert statements for procedure here
	IF NOT EXISTS (SELECT * FROM tUsers U WHERE U.nro_doc = @noDoc) 
	BEGIN 
	INSERT INTO [dbo].[tUsers] (
		[txt_user],
		[txt_password],
		[txt_nombre],
		[txt_apellido],
		[nro_doc],
		[cod_rol],
		[sn_activo]
	)
	values(
		@userName,
		@userPassword,
		@nombre,
		@apellido,
		@noDoc,
		2,
		-1
	)
	END;
	ELSE
	BEGIN
		RAISERROR('Este usuario no fue insertado. Ya existe un usuario con este número de documento', 11, 0)
	END;
END
GO

GO

-- Prueba de procedimiento 1)
 exec [dbo].createUsers 
			@userName  = 'Dawich', 
			@userPassword = 'dawich123',
			@nombre = 'Dawich R', 
			@apellido = 'Rodriguez', 
			@noDoc = '12322'

--2) Crear/Borrar/Modificar peliculas (Borrar es poner en 0 el stock de ventas y alquileres)
-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Manager de peliculas
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
*/
CREATE OR ALTER PROCEDURE manageMovies
	 
/*	 Accion: 
	1 - Agregar
	2- Modificar
	3 - Eliminar 
*/
	@cod_pelicula INT = NULL, 
		@desc VARCHAR(500) = NULL,
		@cant_dispo_alq int = NULL, 
		@cant_dispo_venta int= NULL, 
		@precioAlquiler NUMERIC(18,2) = NULL,
		@precioVenta NUMERIC(18,2) = NULL,
		@accion varchar(1) = NULL
AS
BEGIN
 
	SET NOCOUNT ON;
 
    -- Insert statements for procedure here
	IF NOT EXISTS (SELECT * FROM tPelicula P WHERE P.cod_pelicula = @cod_pelicula) 
	BEGIN 
	IF @accion = '3'
		BEGIN
			RAISERROR('No se puede eliminar esta pelicula debido a que no esta creada', 11, 0)
		END;
	ELSE IF @accion = '2'
		BEGIN
			RAISERROR('No se puede actualizar  esta pelicula debido a que no esta creada', 11, 0)
		END;
	ELSE 
		INSERT INTO [dbo].[tPelicula] (
			[txt_desc],
			[cant_disponibles_alquiler],
			[cant_disponibles_venta],
			[precio_alquiler],
			[precio_venta]
		)
		values(
			@desc,
			@cant_dispo_alq,
			@cant_dispo_venta,
			@precioAlquiler,
			@precioVenta
		)
		PRINT 'Se ha insertado una nueva pelicula'
		END;
	ELSE
		IF @accion = '1'
		BEGIN
			RAISERROR('Ya existe esta pelicula', 11, 0)
		END;
		ELSE IF @accion = '2'
		BEGIN
			UPDATE [dbo].[tPelicula]
			SET txt_desc = @desc,
				cant_disponibles_alquiler =  @cant_dispo_alq,
				cant_disponibles_venta = @cant_dispo_venta,
				precio_alquiler = @precioAlquiler,
				precio_venta = @precioVenta
			WHERE cod_pelicula = @cod_pelicula;

			PRINT 'Se ha actualizado está pelicula'
		END;
		ELSE IF @accion = '3'
		BEGIN
			UPDATE [dbo].[tPelicula]
			SET cant_disponibles_alquiler = 0,
				cant_disponibles_venta = 0,
				precio_alquiler = 0,
				precio_venta = 0
			WHERE cod_pelicula = @cod_pelicula;

			PRINT 'Se ha restablecido el stock de esta eplicula'
		END;

END
GO

-- prueba de procedimiento 
exec [dbo].manageMovies
			@cod_pelicula = 7, 
		@desc = 'Esta pelicula trata de la familia',
		@cant_dispo_alq = 4, 
		@cant_dispo_venta = 5, 
		@precioAlquiler = 8.0,
		@precioVenta = 5.0,
		@accion = '2'

	 
-- 3) Crear géneros
-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Crear generos
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE createGenMovie
		@generoName VARCHAR(500) = NULL
AS
	BEGIN

		SET NOCOUNT ON;
 
		-- Insert statements for procedure here
		IF NOT EXISTS (SELECT * FROM tGenero G WHERE G.txt_desc = @generoName) 
		BEGIN 
		INSERT INTO [dbo].[tGenero] ([txt_desc])
		values(@generoName)
	END;
		ELSE
			BEGIN
				RAISERROR('Este género ya existe', 11, 0)
			END;
	END;
GO

exec createGenMovie
@generoName = 'Humor'

select * from tGenero

--4) Asignar géneros a películas, verificar que la película no tenga asignada el género previamente.

-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Asignar género a pelicula
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE assignGenMovie
		@idPelicula INT = 0,
		@idGenero INT  = 0
AS
	BEGIN

		SET NOCOUNT ON;
 
		-- Insert statements for procedure here
		IF NOT EXISTS (SELECT * FROM tGeneroPelicula GP WHERE GP.cod_pelicula = @idPelicula AND GP.cod_genero = @idGenero) 
		BEGIN 
		INSERT INTO [dbo].[tGeneroPelicula] ([cod_pelicula],[cod_genero])
		values(@idPelicula, @idGenero)
	END;
		ELSE
			BEGIN
				RAISERROR('Esta pélicula ya posee este género, favor asignar otro', 11, 0)
			END;
	END;
GO

exec assignGenMovie
@idPelicula = 1,
@idGenero = 2

select * from [tGeneroPelicula];


--5) Alquilar y Vender películas

-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Alquilar y Vender películas
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE rentSellMovies
		@idPelicula INT = 0,
		@idUsuario INT = 0,
		@cantidadAlquilarVender INT  = 0,
		@alquilaVende varchar(1) = '1'
AS
	BEGIN
			DECLARE @cantDisp int;
		
				SET NOCOUNT ON;
 
				IF EXISTS (SELECT * FROM tPelicula P WHERE P.cod_pelicula = @idPelicula) 
					BEGIN 
						IF @alquilaVende = '1'
						BEGIN
							SET @cantDisp =  (SELECT cant_disponibles_alquiler from tPelicula P where p.cod_pelicula = @idPelicula)
							IF @cantDisp > @cantidadAlquilarVender
								BEGIN
										UPDATE tPelicula
										set cant_disponibles_alquiler = cant_disponibles_alquiler - @cantidadAlquilarVender
										where cod_pelicula = @idPelicula;

										INSERT INTO [dbo].[AlquilerPelicula] ([Cod_Usuario],[cod_pelicula], [precio_alquiler])
										values(@idUsuario, @idPelicula, (select precio_alquiler from tPelicula where cod_pelicula = @idPelicula));
								END;
							ELSE
								BEGIN
									RAISERROR('No puedes alquilar esta cantidad de peliculas, favor elegir otra', 11, 0)
								END;
						END;
						ELSE IF @alquilaVende = '2'
						BEGIN
							SET @cantDisp =  (SELECT cant_disponibles_venta from tPelicula P where p.cod_pelicula = @idPelicula)
							IF @cantDisp > @cantidadAlquilarVender
										BEGIN
										UPDATE tPelicula
										set cant_disponibles_venta = cant_disponibles_venta - @cantidadAlquilarVender
										where cod_pelicula = @idPelicula;

										INSERT INTO [dbo].[VenderPelicula]([Cod_Usuario],[cod_pelicula], [precio])
										values(@idUsuario, @idPelicula, (select precio_venta from tPelicula where cod_pelicula = @idPelicula));
								END;
							ELSE
								BEGIN
									RAISERROR('No puedes VENDER esta cantidad de peliculas, favor elegir otra', 11, 0)
								END;
						END;
					END;
				ELSE
					BEGIN
						RAISERROR('Esta pelicula no esta disponible para venta ni alquiler', 11, 0)
					END;
	END;
GO

exec rentSellMovies
		@idPelicula = 7,
		@idUsuario = 1,
		@cantidadAlquilarVender = 1,
		@alquilaVende = '1'


		exec rentSellMovies
		@idPelicula = 6,
		@idUsuario = 1,
		@cantidadAlquilarVender = 1,
		@alquilaVende = '2'

		SELECT * FROM AlquilerPelicula;

		select * from VenderPelicula;


--6) Obtener las películas en stock para alquiler

-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Revisar Stock Alquiler
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE getStockRent
AS
	BEGIN
			 SELECT * FROM tPelicula P where P.cant_disponibles_alquiler > 0 
	END;
GO

exec getStockRent;

-- 7) Obtener las películas en stock para vender

-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Revisar Stock Venta
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE getStockSell
AS
	BEGIN
			 SELECT * FROM tPelicula P where P.cant_disponibles_venta > 0 
	END;
GO


exec getStockSell;

-- 8) Alquilar película 9) Vender pelicula
-- ver punto 5

-- 10) Devolver película
-- =============================================
-- Author:		Dawich Rodriguez 
-- Description:	Devolver pelicula 
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE returnMovie
		@idAlquiler INT = 0,
		@idPelicula INT = 0,
		@idUsuario INT = 0
AS
	BEGIN
			DECLARE @cantDisp int;
		
				SET NOCOUNT ON;
 
				IF EXISTS (SELECT * FROM tPelicula P WHERE P.cod_pelicula = @idPelicula) 
					BEGIN 
				 
					UPDATE tPelicula
					SET cant_disponibles_alquiler = cant_disponibles_alquiler + 1
					WHERE cod_pelicula = @idPelicula;

					UPDATE [dbo].[AlquilerPelicula]  
					SET EntregoPelicula = 'S'
					WHERE Cod_Usuario = @idUsuario and Cod_Pelicula = @idPelicula and IdAlquilerPelicula = @idAlquiler

					END;
				ELSE
					BEGIN
						RAISERROR('Favor ingresar una pelicula valida', 11, 0)
					END;
	END;
GO

exec returnMovie
@idAlquiler = 1,
@idPelicula =  6,
@idUsuario = 1

SELECT * FROM AlquilerPelicula;

--11) Ver películas que no fueron devueltas y que usuarios la tienen
-- =======================================================
-- Author:		Dawich Rodriguez 
-- Description: Usuarios que no han retornado la pelicula
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE noReturnMovieList
AS
	BEGIN
			 SELECT P.txt_desc as NombrePelicula, U.txt_nombre+U.txt_apellido as NombreUsuario, u.txt_user AS Usuario FROM [dbo].[AlquilerPelicula] A INNER JOIN [dbo].[tUsers] U ON A.Cod_Usuario = U.cod_usuario
			 INNER JOIN [dbo].[tPelicula] P on A.Cod_Pelicula = P.cod_pelicula
			 WHERE A.EntregoPelicula = 'N'
	END;
GO

exec noReturnMovieList;

--12) Ver qué películas fueron alquiladas por usuario y cuánto pagó y que día
-- =======================================================
-- Author:		Dawich Rodriguez 
-- Description: Ver qué películas fueron alquiladas por usuario y cuánto pagó y que día
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE rentMoviesList
AS
	BEGIN
			 SELECT P.txt_desc as NombrePelicula, u.txt_user AS Usuario, A.precio_alquiler as Precio, A.Fecha as Fecha FROM [dbo].[AlquilerPelicula] A INNER JOIN [dbo].[tUsers] U ON A.Cod_Usuario = U.cod_usuario
			 INNER JOIN [dbo].[tPelicula] P on A.Cod_Pelicula = P.cod_pelicula
			 WHERE A.EntregoPelicula = 'N'
	END;
GO


exec rentMoviesList;

--13) Ver todas las películas, cuantas veces fueron alquiladas y cuanto se recaudo por ellas

-- =======================================================
-- Author:		Dawich Rodriguez 
-- Description: Ver todas las películas, cuantas veces fueron alquiladas y cuanto se recaudo por
--ellas
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE rentMoviesCountList
AS
	BEGIN
		SELECT P.txt_desc as NombrePelicula, 
		(select COUNT(A.Cod_Pelicula) from AlquilerPelicula A where Cod_Pelicula = P.cod_pelicula) as CantidadAlquilada,
		(select SUM(A.precio_alquiler) from AlquilerPelicula A where Cod_Pelicula = P.cod_pelicula) as DineroRecaudado
		FROM tPelicula P
	END;
GO

exec rentMoviesCountList;