-- Bảng users
CREATE TABLE users (
    user_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100),
    phone_number NVARCHAR(20),
    role NVARCHAR(20) NOT NULL CHECK (role IN ('CUSTOMER', 'ADMIN')),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    password_reset_token NVARCHAR(255) NULL,
    token_expiry_date DATETIME NULL
);

-- Bảng addresses
CREATE TABLE addresses (
    address_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT,
    street_address NVARCHAR(255) NOT NULL,
    ward NVARCHAR(100),
    district NVARCHAR(100) NOT NULL,
    city_province NVARCHAR(100) NOT NULL,
    postal_code NVARCHAR(20),
    country NVARCHAR(50) DEFAULT 'Vietnam',
    address_type NVARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_default BIT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Bảng categories
CREATE TABLE categories (
    category_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(MAX),
    image_url NVARCHAR(255),
    parent_category_id BIGINT,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id) ON DELETE NO ACTION
);

-- Bảng restaurants
CREATE TABLE restaurants (
    restaurant_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    phone_number NVARCHAR(20),
    address_id BIGINT UNIQUE,
    operating_hours NVARCHAR(255),
    logo_image_url NVARCHAR(255),
    cover_image_url NVARCHAR(255),
    average_rating DECIMAL(3, 2) DEFAULT 0.00,
    is_approved BIT DEFAULT 0,
    is_active BIT DEFAULT 1,
    owner_user_id BIGINT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE SET NULL,
    FOREIGN KEY (owner_user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Bảng menu_items
CREATE TABLE menu_items (
    item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    restaurant_id BIGINT NOT NULL,
    category_id BIGINT,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    image_url NVARCHAR(255),
    is_available BIT DEFAULT 1,
    preparation_time_minutes INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- Bảng orders
CREATE TABLE orders (
    order_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_user_id BIGINT NOT NULL,
    restaurant_id BIGINT NOT NULL,
    delivery_address_id BIGINT,
    order_datetime DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(12, 2) NOT NULL,
    order_status NVARCHAR(50) NOT NULL DEFAULT 'PENDING',
    payment_status NVARCHAR(50) NOT NULL DEFAULT 'PENDING',
    payment_method NVARCHAR(50),
    notes NVARCHAR(MAX),
    estimated_delivery_time DATETIME NULL,
    actual_delivery_time DATETIME NULL,
    delivery_fee DECIMAL(10,2) DEFAULT 0.00,
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_user_id) REFERENCES users(user_id) ON DELETE NO ACTION,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE NO ACTION,
    FOREIGN KEY (delivery_address_id) REFERENCES addresses(address_id) ON DELETE SET NULL
);

-- Bảng order_items
CREATE TABLE order_items (
    order_item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_per_item DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    notes NVARCHAR(MAX),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id) ON DELETE NO ACTION
);