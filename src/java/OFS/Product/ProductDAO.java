/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Product;

import OFS.Category.CategoryDAO;
import OFS.Category.CategoryDTO;
import OFS.Review.ReviewDTO;
import OFS.Users.UsersDTO;
import dal.DBContext;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nguye
 */
public class ProductDAO extends DBContext {

    public List<ProductImages> getProductImagesByProductId(int productId) {
        List<ProductImages> images = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY product_image_id";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Product product = getProductById(rs.getInt("product_id")); // Lấy thông tin sản phẩm
                ProductImages image = new ProductImages(
                        rs.getInt("product_image_id"),
                        product,
                        rs.getString("image_url")
                );
                images.add(image);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching product images: " + e.getMessage());
            e.printStackTrace();
        }
        return images;
    }

    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                CategoryDAO dao = new CategoryDAO();
                int categoryId = rs.getInt("category_id");
                CategoryDTO c = dao.getCategoryById(categoryId);

                Product p = new Product(rs.getInt("product_id"), rs.getString("name"), rs.getString("description"),
                        rs.getBigDecimal("base_price"), c, rs.getString("brand"), rs.getString("material"), createdAt);
                return p;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }


    public ProductVariant getProductVariantById(int id) {
        String sql = "SELECT pv.*, p.*, c.* FROM product_variants pv "
                + "JOIN products p ON pv.product_id = p.product_id "
                + "JOIN categories c ON p.category_id = c.category_id "
                + "WHERE pv.variant_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                CategoryDTO category = new CategoryDTO(rs.getInt("category_id"), rs.getString("name"), rs.getString("description"), createdAt, rs.getString("image_url"));
                Product product = new Product(rs.getInt("product_id"), rs.getString("name"), rs.getString("description"), rs.getBigDecimal("base_price"),
                        category, rs.getString("brand"), rs.getString("material"), createdAt);
                return new ProductVariant(rs.getInt("variant_id"), product, rs.getString("size"), rs.getString("color"),
                        rs.getBigDecimal("price"), rs.getInt("stock_quantity"), createdAt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> productList = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            CategoryDAO categoryDAO = new CategoryDAO();
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                CategoryDTO category = categoryDAO.getCategoryById(categoryId);
                Product p = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("base_price"),
                        category,
                        rs.getString("brand"),
                        rs.getString("material"),
                        createdAt
                );
                productList.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching products by category: " + e.getMessage());
            e.printStackTrace();
        }
        return productList;
    }

    public List<Product> searchProductsByName(String query) {
        List<Product> products = new ArrayList<>();
        query = query.trim().toLowerCase();

        String sql = "SELECT p.* "
                + "FROM products p "
                + "INNER JOIN categories c ON p.category_id = c.category_id "
                + "WHERE (LOWER(c.name) LIKE ? OR LOWER(p.name) LIKE ? OR LOWER(p.description) LIKE ?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchQuery = "%" + query + "%";
            st.setString(1, searchQuery);
            st.setString(2, searchQuery);
            st.setString(3, searchQuery);

            ResultSet rs = st.executeQuery();
            CategoryDAO categoryDAO = new CategoryDAO();
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                int categoryId = rs.getInt("category_id");
                CategoryDTO category = categoryDAO.getCategoryById(categoryId);
                Product p = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("base_price"),
                        category,
                        rs.getString("brand"),
                        rs.getString("material"),
                        createdAt
                );
                products.add(p);
                System.out.println("[ProductDAO] Found product: " + p.getName());

            }
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("[ProductDAO] Total products found: " + products.size());
        return products;
    }

    public List<Product> getLatestProducts() {
        List<Product> latestProducts = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM products ORDER BY created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            CategoryDAO categoryDAO = new CategoryDAO();
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                int categoryId = rs.getInt("category_id");
                CategoryDTO category = categoryDAO.getCategoryById(categoryId);
                Product p = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("base_price"),
                        category,
                        rs.getString("brand"),
                        rs.getString("material"),
                        createdAt
                );
                latestProducts.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching latest products: " + e.getMessage());
            e.printStackTrace();
        }
        return latestProducts;
    }

    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            ResultSet rs = st.executeQuery();
            Product product = getProductById(productId);
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                ProductVariant variant = new ProductVariant(
                        rs.getInt("variant_id"),
                        product,
                        rs.getString("size"),
                        rs.getString("color"),
                        rs.getBigDecimal("price"),
                        rs.getInt("stock_quantity"),
                        createdAt
                );
                variants.add(variant);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching variants: " + e.getMessage());
            e.printStackTrace();
        }
        return variants;
    }

    public List<String> getAllColors() {
        List<String> colors = new ArrayList<>();
        String sql = "SELECT DISTINCT color FROM product_variants WHERE color IS NOT NULL AND color != ''";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String color = rs.getString("color");
                if (color != null && !color.trim().isEmpty()) {
                    colors.add(color);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching colors: " + e.getMessage());
            e.printStackTrace();
        }
        return colors;
    }

    public List<ReviewDTO> getReviewsByProductId(int productId) {
        List<ReviewDTO> reviews = new ArrayList<>();
        String sql = "SELECT r.review_id, r.user_id, r.product_id, r.rating, r.comment, r.created_at, "
                + "u.first_name, u.last_name, u.email, u.phone, u.address "
                + "FROM reviews r "
                + "JOIN users u ON r.user_id = u.user_id "
                + "WHERE r.product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                UsersDTO user = new UsersDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));

                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));

                ReviewDTO review = new ReviewDTO();
                review.setReviewId(rs.getInt("review_id"));
                review.setUser(user);
                review.setProduct(product);
                review.setRating(rs.getInt("rating")); // Đảm bảo lấy đúng giá trị rating
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching reviews: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }


    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.name, p.description, p.base_price, "
                + "p.brand, p.material, p.created_at, "
                + "c.category_id, c.name AS category_name, c.description AS category_description, "
                + "c.created_at AS category_created_at, c.image_url AS category_image_url, "
                + "(SELECT TOP 1 pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id ORDER BY pi.product_image_id) AS product_image_url "
                + "FROM products p "
                + "LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE LOWER(p.name) LIKE ? "
                + "   OR LOWER(p.brand) LIKE ? "
                + "   OR LOWER(p.description) LIKE ? "
                + "   OR LOWER(c.name) LIKE ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword.toLowerCase() + "%";
            for (int i = 1; i <= 4; i++) {
                st.setString(i, searchKeyword);
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    // Xử lý thời gian tạo danh mục
                    Timestamp categoryTimestamp = rs.getTimestamp("category_created_at");
                    LocalDateTime categoryCreatedAt = (categoryTimestamp != null) ? categoryTimestamp.toLocalDateTime() : null;

                    // Tạo đối tượng CategoryDTO
                    CategoryDTO category = new CategoryDTO(
                            rs.getInt("category_id"),
                            rs.getString("category_name"),
                            rs.getString("category_description"),
                            categoryCreatedAt,
                            rs.getString("category_image_url") // Hình ảnh của danh mục
                    );

                    // Xử lý thời gian tạo sản phẩm
                    Timestamp productTimestamp = rs.getTimestamp("created_at");
                    LocalDateTime productCreatedAt = (productTimestamp != null) ? productTimestamp.toLocalDateTime() : null;

                    // Tạo đối tượng Product
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getBigDecimal("base_price"),
                            category,
                            rs.getString("brand"),
                            rs.getString("material"),
                            productCreatedAt
                    );

                    // Lấy và gán hình ảnh cho sản phẩm
                    String productImageUrl = rs.getString("product_image_url");
                    if (productImageUrl != null && !productImageUrl.trim().isEmpty()) {
                        ProductImages productImage = new ProductImages();
                        productImage.setImageUrl(productImageUrl);
                        product.setProductImage(productImage);
                    }

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getProductsWithPagination(int offset, int limit, String sort) throws Exception {
        List<Product> productList = new ArrayList<>();

        String orderBy = "p.product_id"; 
        switch (sort.toLowerCase()) {
            case "asc":
                orderBy = "p.base_price ASC";
                break;
            case "desc":
                orderBy = "p.base_price DESC";
                break;
            case "category_asc":
                orderBy = "c.name ASC";
                break;
            case "category_desc":
                orderBy = "c.name DESC";
                break;
            case "none":
            default:
                orderBy = "p.product_id"; 
                break;
        }

        String sql = "SELECT p.product_id, p.name AS product_name, c.name AS category_name, "
                + "p.brand, p.material, p.base_price, "
                + "(SELECT TOP 1 pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id) AS image_url "
                + "FROM products p "
                + "LEFT JOIN categories c ON p.category_id = c.category_id "
                + "ORDER BY " + orderBy
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    String name = rs.getString("product_name");
                    String categoryName = rs.getString("category_name");
                    String brand = rs.getString("brand");
                    String material = rs.getString("material");
                    BigDecimal basePrice = rs.getBigDecimal("base_price");
                    String imageUrl = rs.getString("image_url");

                    CategoryDTO category = new CategoryDTO(0, categoryName);
                    ProductImages productImage = new ProductImages();
                    productImage.setImageUrl(imageUrl);

                    Product product = new Product(productId, name, "", basePrice, category, brand, material, null);
                    product.setProductImage(productImage);

                    productList.add(product);
                }
            }
        }
        return productList;
    }

// Đếm tổng số sản phẩm để tính số trang
    public int getTotalProducts() throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM products";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    public List<ProductVariant> getProductVariantsByProductId(int productId) throws Exception {
        List<ProductVariant> variants = new ArrayList<>();

        Product product = getProductById(productId);
        if (product == null) {
            System.out.println("Product not found for ID: " + productId);
            return variants; 
        }

        String sql = "SELECT variant_id, size, color, price, stock_quantity, created_at FROM product_variants WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                    ProductVariant variant = new ProductVariant(
                            rs.getInt("variant_id"),
                            product,
                            rs.getString("size"),
                            rs.getString("color"),
                            rs.getBigDecimal("price"),
                            rs.getInt("stock_quantity"),
                            createdAt
                    );
                    variants.add(variant);
                }
            }
        }
        return variants;
    }

    public boolean insertProductImage(ProductImages productImage) {
        String sql = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
        try (
                PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productImage.getProduct().getProductId());
            stmt.setString(2, productImage.getImageUrl());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int insertProductVariant(ProductVariant variant) {
        String sql = "INSERT INTO product_variants (product_id, size, color, price, stock_quantity) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, variant.getProduct().getProductId());
            stmt.setString(2, variant.getSize());
            stmt.setString(3, variant.getColor());
            stmt.setBigDecimal(4, variant.getPrice());
            stmt.setInt(5, variant.getStockQuantity());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int variantId = generatedKeys.getInt(1);
                        variant.setVariantId(variantId); // Cập nhật variantId vào đối tượng variant
                        System.out.println("Inserted Variant: " + variant.getSize() + ", " + variant.getColor() + " - Variant ID: " + variantId);
                        return variantId;
                    }
                }
            }
            return -1; 
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public int insertProductAndGetId(Product product) {
        String sql = "INSERT INTO products (name, description, base_price, category_id, brand, material) VALUES (?, ?, ?, ?, ?, ?)";
        try (
                PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getBasePrice());
            stmt.setInt(4, product.getCategory().getCategoryId());
            stmt.setString(5, product.getBrand());
            stmt.setString(6, product.getMaterial());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Product> getProductsByCategoryWithPagination(String categoryName, int offset, int limit, String sort) throws Exception {
        List<Product> productList = new ArrayList<>();
        String orderBy = "p.product_id"; 

        if ("asc".equalsIgnoreCase(sort)) {
            orderBy = "p.base_price ASC";
        } else if ("desc".equalsIgnoreCase(sort)) {
            orderBy = "p.base_price DESC";
        }

        String sql;
        if ("all".equalsIgnoreCase(categoryName)) {
            sql = "SELECT p.product_id, p.name AS product_name, p.category_id, "
                    + "p.brand, p.material, p.base_price, "
                    + "(SELECT TOP 1 pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id) AS image_url "
                    + "FROM products p "
                    + "JOIN categories c ON p.category_id = c.category_id "
                    + "ORDER BY " + orderBy
                    + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else {
            sql = "SELECT p.product_id, p.name AS product_name, p.category_id, "
                    + "p.brand, p.material, p.base_price, "
                    + "(SELECT TOP 1 pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id) AS image_url "
                    + "FROM products p "
                    + "JOIN categories c ON p.category_id = c.category_id "
                    + "WHERE LOWER(c.name) = LOWER(?) "
                    + "ORDER BY " + orderBy
                    + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (!"all".equalsIgnoreCase(categoryName)) {
                ps.setString(1, categoryName);
                ps.setInt(2, offset);
                ps.setInt(3, limit);
            } else {
                ps.setInt(1, offset);
                ps.setInt(2, limit);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    String name = rs.getString("product_name");
                    int productCategoryId = rs.getInt("category_id");
                    String brand = rs.getString("brand");
                    String material = rs.getString("material");
                    BigDecimal basePrice = rs.getBigDecimal("base_price");
                    String imageUrl = rs.getString("image_url");

                    CategoryDTO category = new CategoryDTO(productCategoryId, categoryName);
                    ProductImages productImage = new ProductImages();
                    productImage.setImageUrl(imageUrl);

                    Product product = new Product(productId, name, "", basePrice, category, brand, material, null);
                    product.setProductImage(productImage);

                    productList.add(product);
                }
            }
        }
        return productList;
    }

    public int getTotalProducts(String categoryName) throws Exception {
        String sql;
        boolean filterByCategory = categoryName != null && !"all".equalsIgnoreCase(categoryName);

        if (filterByCategory) {
            sql = "SELECT COUNT(*) FROM products p "
                    + "JOIN categories c ON p.category_id = c.category_id "
                    + "WHERE LOWER(c.name) = LOWER(?)";
        } else {
            sql = "SELECT COUNT(*) FROM products";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (filterByCategory) {
                ps.setString(1, categoryName);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0; 
    }

    public int getTotalProductsByCategory(int categoryId) throws Exception {
        String sql = "SELECT COUNT(*) AS total FROM products WHERE category_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    public int getCategoryIdByName(String categoryName) throws Exception {
        String sql = "SELECT category_id FROM categories WHERE name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("category_id");
                }
            }
        }
        return -1; 
    }

    public boolean updateProduct(Product updatedProduct) throws SQLException {
        String sql = "UPDATE products SET name=?, description=?, base_price=?, category_id=?, brand=?, material=?, image_url=? WHERE product_id=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, updatedProduct.getName());
            ps.setString(2, updatedProduct.getDescription());
            ps.setBigDecimal(3, updatedProduct.getBasePrice());
            ps.setInt(4, updatedProduct.getCategory().getCategoryId());
            ps.setString(5, updatedProduct.getBrand());
            ps.setString(6, updatedProduct.getMaterial());
            ps.setString(7, updatedProduct.getProductImage().getImageUrl()); // Lưu imageUrl
            ps.setInt(8, updatedProduct.getProductId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";

        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, productId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0; 
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; 
    }

    public Product getProductImagesById(int productId) {
        String sql = "SELECT p.*, i.image_url FROM Product p "
                + "LEFT JOIN ProductImages i ON p.product_id = i.product_id "
                + "WHERE p.product_id = ?";

        try (
                PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setProductId(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));

                    ProductImages productImage = new ProductImages();
                    productImage.setImageUrl(rs.getString("image_url"));

                    product.setProductImage(productImage); 

                    return product;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProductVariant(int variantId, String size, String color, BigDecimal price, int stockQuantity) {
        String sql = "UPDATE product_variants "
                + "SET size = ?, color = ?, price = ?, stock_quantity = ? "
                + "WHERE variant_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
           
            if (size == null || size.trim().isEmpty()
                    || color == null || color.trim().isEmpty()
                    || price == null || stockQuantity < 0) {
                return false; 
            }

            ps.setString(1, size);
            ps.setString(2, color);
            ps.setBigDecimal(3, price);
            ps.setInt(4, stockQuantity);
            ps.setInt(5, variantId);

            return ps.executeUpdate() > 0; 
        } catch (SQLException e) {

        }
        return false;
    }

    // 🗑️ Xóa Product Variant
    public boolean deleteProductVariant(int variantId) throws SQLException {
        String sql = "DELETE FROM product_variants WHERE variant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            return ps.executeUpdate() > 0; 
        }
    }

    public ProductVariant getVariantById(int variantId) throws SQLException {
        String sql = "SELECT * FROM product_variants WHERE variant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new ProductVariant(
                        rs.getInt("variant_id"),
                        new Product(rs.getInt("product_id")), 
                        rs.getString("size"),
                        rs.getString("color"),
                        rs.getBigDecimal("price"),
                        rs.getInt("stock_quantity"),
                        rs.getTimestamp("created_at").toLocalDateTime()
                );
            }
        }
        return null; 
    }

    public List<Product> searchProductsWithPagination(String keyword, int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.name, p.description, p.base_price, "
                + "p.brand, p.material, p.created_at, "
                + "c.category_id, c.name AS category_name, c.description AS category_description, "
                + "c.created_at AS category_created_at, c.image_url "
                + "FROM products p "
                + "LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE LOWER(p.name) LIKE ? "
                + "   OR LOWER(p.brand) LIKE ? "
                + "   OR LOWER(p.description) LIKE ? "
                + "   OR LOWER(c.name) LIKE ? "
                + "ORDER BY p.product_id "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword.toLowerCase() + "%";
            for (int i = 1; i <= 4; i++) {
                st.setString(i, searchKeyword);
            }
            st.setInt(5, offset);
            st.setInt(6, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Timestamp categoryTimestamp = rs.getTimestamp("category_created_at");
                    LocalDateTime categoryCreatedAt = (categoryTimestamp != null) ? categoryTimestamp.toLocalDateTime() : null;

                    CategoryDTO category = new CategoryDTO(
                            rs.getInt("category_id"),
                            rs.getString("category_name"),
                            rs.getString("category_description"),
                            categoryCreatedAt,
                            rs.getString("image_url")
                    );

                    Timestamp productTimestamp = rs.getTimestamp("created_at");
                    LocalDateTime productCreatedAt = (productTimestamp != null) ? productTimestamp.toLocalDateTime() : null;

                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getBigDecimal("base_price"),
                            category,
                            rs.getString("brand"),
                            rs.getString("material"),
                            productCreatedAt
                    );

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public int getTotalSearchProducts(String keyword) {
        String sql = "SELECT COUNT(*) "
                + "FROM products p "
                + "LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE LOWER(p.name) LIKE ? "
                + "   OR LOWER(p.brand) LIKE ? "
                + "   OR LOWER(p.description) LIKE ? "
                + "   OR LOWER(c.name) LIKE ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword.toLowerCase() + "%";
            for (int i = 1; i <= 4; i++) {
                st.setString(i, searchKeyword);
            }

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getStockQuantity(int variantId) throws SQLException {
        String sql = "SELECT stock_quantity FROM product_variants WHERE variant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("stock_quantity");
                }
            }
        }
        return -1; 
    }

    public boolean updateStockQuantity(int variantId, int newQuantity) throws SQLException {
        String sql = "UPDATE product_variants SET stock_quantity = ? WHERE variant_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, variantId);
            return ps.executeUpdate() > 0; 
        }
    }

}
