-- Insercion de datos
-- Inserción en la tabla Desarrolladores
INSERT INTO Desarrolladores (nombreDesarrollador) VALUES
('Nintendo'),
('Sony Interactive Entertainment'),
('Electronic Arts'),
('Ubisoft'),
('Valve');

-- Inserción en la tabla Videojuegos
INSERT INTO Videojuegos (titulo, desarrolladorID, fechaLanzamiento, precio) VALUES
('Super Mario Odyssey', 1, '2017-10-27', 59.99),
('The Last of Us Part II', 2, '2020-06-19', 69.99),
('FIFA 23', 3, '2022-09-30', 49.99),
('Assassin’s Creed Valhalla', 4, '2020-11-10', 39.99),
('Half-Life: Alyx', 5, '2020-03-23', 29.99);

-- Inserción en la tabla Usuarios
INSERT INTO Usuarios (nombreUsuario, email, Password) VALUES
('GastonZarate', 'gastonzarate25@gmail.com', 'password123'),
('JulianZarate', 'julianzarate@gmail.com', 'password123'),
('CarlosDiaz', 'carlos.diaz@gmail.com', 'password123'),
('AnaGarcia', 'ana.garcia@gmail.com', 'password123'),
('CandeActis', 'Candeactis@gmail.com', 'password123');

-- Inserción en la tabla Ventas
INSERT INTO Ventas (userID, juegoID, fechaCompra, precioCompra, tipo_de_pago) VALUES
(1, 1, '2023-12-15', 59.99, 'CREDITO'),
(2, 2, '2023-12-10', 69.99, 'CRYPTOMONEDA'),
(3, 3, '2023-12-12', 44.99, 'DEBITO');

-- Inserción en la tabla Reseña
INSERT INTO Reseña (userID, juegoID, calificacion, comentario) VALUES
(1, 1, 5, 'Un juego espectacular, lleno de diversión.'),
(2, 2, 4, 'Buena historia, pero esperaba más del final.'),
(3, 3, 3, 'Es entretenido, pero no mucho más que versiones anteriores.'),
(4, 4, 5, 'Un juego épico, lo mejor de la saga.'),
(5, 5, 4, 'Una experiencia de realidad virtual impresionante.');

-- Inserción en la tabla Biblioteca
INSERT INTO Biblioteca (userID, juegoID, fecha_de_adicion) VALUES
(1, 1, '2023-12-15'),
(2, 2, '2023-12-10'),
(3, 3, '2023-12-12'),
(4, 4, '2023-12-05'),
(5, 5, '2023-12-07');
