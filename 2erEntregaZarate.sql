DROP DATABASE IF EXISTS PlataformaVideojuegos;
CREATE DATABASE PlataformaVideojuegos;

USE PlataformaVideojuegos;

CREATE TABLE PlataformaVideojuegos.Desarrolladores (
    desarrolladorID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombreDesarrollador VARCHAR(100)
);


CREATE TABLE PlataformaVideojuegos.Videojuegos (
    juegoID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100),
    desarrolladorID INT,
    fechaLanzamiento DATE,
    precio DECIMAL(10, 2),
    FOREIGN KEY (desarrolladorID) REFERENCES desarrolladores(desarrolladorID)
);

CREATE TABLE PlataformaVideojuegos.Usuarios (
    userID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombreUsuario VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    Password VARCHAR(100)
);

CREATE TABLE PlataformaVideojuegos.Ventas (
    ventasID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    juegoID INT,
    fechaCompra DATE,
    precioCompra DECIMAL(10, 2),
    tipo_de_pago ENUM('DEBITO','CRYPTOMONEDA','CREDITO'),
    FOREIGN KEY (userID) REFERENCES Usuarios(userID),
    FOREIGN KEY (juegoID) REFERENCES Videojuegos(juegoID)
);

CREATE TABLE PlataformaVideojuegos.Reseña (
    reseñaID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    juegoID INT,
    calificacion INT,
    comentario TEXT,
    FOREIGN KEY (userID) REFERENCES Usuarios(userID),
    FOREIGN KEY (juegoID) REFERENCES Videojuegos(juegoID)
);

CREATE TABLE PlataformaVideojuegos.Biblioteca (
    bibliotecaID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    juegoID INT,
    fecha_de_adicion DATE,
    FOREIGN KEY (userID) REFERENCES Usuarios(userID),
    FOREIGN KEY (juegoID) REFERENCES Videojuegos(juegoID)
);

-- Vistas
-- Vista1
CREATE VIEW vista_usuarios_compras AS
SELECT 
    u.userID, 
    u.nombreUsuario, 
    v.juegoID, 
    j.titulo AS tituloJuego, 
    v.fechaCompra, 
    v.precioCompra
FROM Usuarios u
JOIN Ventas v ON u.userID = v.userID
JOIN Videojuegos j ON v.juegoID = j.juegoID;

-- Vista2
CREATE VIEW vista_resumen_ventas AS
SELECT 
    j.juegoID, 
    j.titulo AS tituloJuego, 
    COUNT(v.ventasID) AS totalVentas, 
    SUM(v.precioCompra) AS ingresosTotales, 
    AVG(v.precioCompra) AS precioPromedio
FROM Ventas v
JOIN Videojuegos j ON v.juegoID = j.juegoID
GROUP BY j.juegoID, j.titulo;

-- Vista3
CREATE VIEW vista_biblioteca_usuarios AS
SELECT 
    u.userID, 
    u.nombreUsuario, 
    b.juegoID, 
    j.titulo AS tituloJuego, 
    b.fecha_de_adicion
FROM Usuarios u
JOIN Biblioteca b ON u.userID = b.userID
JOIN Videojuegos j ON b.juegoID = j.juegoID;

-- Funciones 
-- Funcion1
DELIMITER $$

CREATE FUNCTION calcular_ingreso_total_usuario(userIdParam INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE ingreso_total DECIMAL(10, 2);
    SELECT SUM(precioCompra) INTO ingreso_total
    FROM Ventas
    WHERE userID = userIdParam;
    RETURN IFNULL(ingreso_total, 0);
END $$

DELIMITER ;

SELECT calcular_ingreso_total_usuario(1) AS ingresoTotalUsuario;

-- Funcion2
DELIMITER $$

CREATE FUNCTION promedio_calificacion_juego(juegoIdParam INT) 
RETURNS DECIMAL(3, 2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(3, 2);
    SELECT AVG(calificacion) INTO promedio
    FROM Reseña
    WHERE juegoID = juegoIdParam;
    RETURN IFNULL(promedio, 0);
END $$

DELIMITER ;

SELECT promedio_calificacion_juego(101) AS promedioCalificacion;
-- Funcion3
DELIMITER $$

CREATE FUNCTION conteo_juegos_usuario(userIdParam INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(juegoID) INTO cantidad
    FROM Biblioteca
    WHERE userID = userIdParam;
    RETURN cantidad;
END $$

DELIMITER ;

SELECT conteo_juegos_usuario(3) AS totalJuegosUsuario;

-- Stored Procedures
-- Stored Procedures1
DELIMITER $$

CREATE PROCEDURE registrar_nueva_venta(
    IN p_userID INT, 
    IN p_juegoID INT, 
    IN p_precioCompra DECIMAL(10, 2), 
    IN p_tipoPago ENUM('DEBITO', 'CRYPTOMONEDA', 'CREDITO')
)
BEGIN
    INSERT INTO Ventas (userID, juegoID, fechaCompra, precioCompra, tipo_de_pago)
    VALUES (p_userID, p_juegoID, CURDATE(), p_precioCompra, p_tipoPago);
END $$

DELIMITER ;

-- Stored Procedures2
DELIMITER $$

CREATE PROCEDURE actualizar_precio_videojuego(
    IN p_juegoID INT, 
    IN p_nuevoPrecio DECIMAL(10, 2)
)
BEGIN
    UPDATE Videojuegos
    SET precio = p_nuevoPrecio
    WHERE juegoID = p_juegoID;
END $$

DELIMITER ;

CALL actualizar_precio_videojuego(101, 49.99);

-- Stored Procedures3
DELIMITER $$

CREATE PROCEDURE agregar_resena(
    IN p_userID INT, 
    IN p_juegoID INT, 
    IN p_calificacion INT, 
    IN p_comentario TEXT
)
BEGIN
    INSERT INTO Reseña (userID, juegoID, calificacion, comentario)
    VALUES (p_userID, p_juegoID, p_calificacion, p_comentario);
END $$

DELIMITER ;


-- Tiggers
-- Tiggers1
DELIMITER $$

CREATE TRIGGER actualizar_precio_venta
BEFORE INSERT ON Ventas
FOR EACH ROW
BEGIN
    IF NEW.tipo_de_pago = 'CRYPTOMONEDA' THEN
        SET NEW.precioCompra = NEW.precioCompra * 0.9;
    END IF;
END $$

DELIMITER ;

-- Tigger2
DELIMITER $$

CREATE TRIGGER actualizar_fecha_biblioteca
AFTER INSERT ON Biblioteca
FOR EACH ROW
BEGIN
    UPDATE Biblioteca
    SET fecha_de_adicion = NOW()
    WHERE bibliotecaID = NEW.bibliotecaID;
END $$

DELIMITER ;


