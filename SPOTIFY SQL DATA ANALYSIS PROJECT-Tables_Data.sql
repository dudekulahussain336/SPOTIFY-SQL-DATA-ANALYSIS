CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    title VARCHAR(100),
    reports_to INT,
    birth_date DATE,
    hire_date DATE,
    email VARCHAR(100),
    FOREIGN KEY (reports_to) REFERENCES employee(employee_id)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50),
    support_rep_id INT,
    FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id)
);

CREATE TABLE artist (
    artist_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120)
);

CREATE TABLE album (
    album_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(160),
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

CREATE TABLE genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120)
);

CREATE TABLE media_type (
    media_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120)
);

CREATE TABLE track (
    track_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (album_id) REFERENCES album(album_id),
    FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id),
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);

CREATE TABLE playlist (
    playlist_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120)
);

CREATE TABLE playlist_track (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
    FOREIGN KEY (track_id) REFERENCES track(track_id)
);

CREATE TABLE invoice (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    invoice_date DATETIME,
    billing_address VARCHAR(200),
    billing_city VARCHAR(50),
    billing_country VARCHAR(50),
    total DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE invoice_line (
    invoice_line_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    track_id INT,
    unit_price DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (track_id) REFERENCES track(track_id)
);
