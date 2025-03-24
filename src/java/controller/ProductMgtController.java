/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Category.CategoryDAO;
import OFS.Category.CategoryDTO;
import OFS.Inventory.InventoryLogDAO;
import OFS.Inventory.InventoryLogDTO;
import OFS.Product.Product;
import OFS.Product.ProductDAO;
import OFS.Product.ProductImages;
import OFS.Product.ProductVariant;
import OFS.Users.UsersDTO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Acer
 */
@WebServlet(name = "ProductMgtController", urlPatterns = {"/ProductMgtController"})
public class ProductMgtController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();

        if ("viewVariants".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                Product product = productDAO.getProductById(productId);

                if (product == null) {
                    response.sendRedirect("productmanagement.jsp?error=product_not_found");
                    return;
                }

                List<ProductVariant> variants = productDAO.getProductVariantsByProductId(productId);

                request.setAttribute("product", product);
                request.setAttribute("variants", variants);
                request.getRequestDispatcher("productVariant.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching variants");
            }
        } else if ("edit".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));

            Product product = productDAO.getProductById(productId);

            CategoryDAO categoryDAO = new CategoryDAO();
            List<CategoryDTO> categories = categoryDAO.getAllCategories();

            if (product != null && categories != null) {
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
            } else {
                response.sendRedirect("productmanagement.jsp?error=ProductOrCategoriesNotFound");
            }
        } else if ("updateProduct".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                BigDecimal basePrice = new BigDecimal(request.getParameter("basePrice"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String brand = request.getParameter("brand");
                String material = request.getParameter("material");
                String imageUrl = request.getParameter("imageUrl");

                Product updatedProduct = new Product(productId, name, description, basePrice, new CategoryDTO(categoryId, ""), brand, material, null);
                updatedProduct.setProductImage(new ProductImages(imageUrl));

                boolean success = productDAO.updateProduct(updatedProduct);
                response.sendRedirect("productmanagement.jsp?update=" + success);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("productmanagement.jsp?update=false");
            }
        } else if ("deleteProduct".equals(action)) {
            boolean success = false;

            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                System.out.println("Đang xóa productId: " + productId);

                success = productDAO.deleteProduct(productId);
                System.out.println("Xóa thành công? " + success);

            } catch (Exception e) {
                e.printStackTrace();
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": " + success + "}");
        } else if ("editVariant".equals(action)) {
            try {
                int variantId = Integer.parseInt(request.getParameter("variantId"));

                ProductVariant variant = productDAO.getVariantById(variantId);

                if (variant != null) {
                    request.setAttribute("variant", variant);
                    request.setAttribute("productId", variant.getProduct().getProductId());
                    request.getRequestDispatcher("updateVariant.jsp").forward(request, response);
                } else {
                    response.sendRedirect("productVariant.jsp?error=variant_not_found");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("productVariant.jsp?error=invalid_variant_id");
            } catch (SQLException ex) {
                Logger.getLogger(ProductMgtController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        try {
            int page = 1;
            int recordsPerPage = 10;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            int offset = (page - 1) * recordsPerPage;

            String sort = request.getParameter("sort");
            if (sort == null || sort.trim().isEmpty() || "none".equalsIgnoreCase(sort)) {
                sort = "none";
            }

            String categoryName = request.getParameter("category");
            if (categoryName == null || "all".equalsIgnoreCase(categoryName)) {
                categoryName = "all";
            }

            String keyword = request.getParameter("keyword");
            List<Product> products;
            int totalRecords;

            if (keyword != null && !keyword.trim().isEmpty()) {
                products = productDAO.searchProducts(keyword);
                totalRecords = products.size();
            } else {
                if (!"all".equalsIgnoreCase(categoryName)) {
                    products = productDAO.getProductsByCategoryWithPagination(categoryName, offset, recordsPerPage, sort);
                } else {
                    products = productDAO.getProductsWithPagination(offset, recordsPerPage, sort);
                }
                totalRecords = productDAO.getTotalProducts(categoryName);
            }

            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            request.setAttribute("products", products);
            request.setAttribute("selectedSort", sort);
            request.setAttribute("selectedCategory", categoryName);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);

            request.getRequestDispatcher("productmanagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching product list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();
        InventoryLogDAO inventoryLogDAO = new InventoryLogDAO(); 

        if (action == null) {
            response.sendRedirect("productmanagement.jsp");
            return;
        }

        HttpSession session = request.getSession();
        UsersDTO admin = (UsersDTO) session.getAttribute("account");
        if (admin == null) {
            response.sendRedirect("login.jsp?error=PleaseLogin");
            return;
        }
        int adminId = admin.getUserId();

        if (action.equals("selectCategory")) {
            try {
                String categoryIdStr = request.getParameter("category_id");

                if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                    response.sendRedirect("addCategory.jsp?error=empty_category");
                    return;
                }

                int categoryId = Integer.parseInt(categoryIdStr);
                response.sendRedirect("addProduct.jsp?category_id=" + categoryId);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("addCategory.jsp?error=exception");
            }
            return;
        }

        if (action.equals("insertProduct")) {
            try {
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                BigDecimal basePrice = new BigDecimal(request.getParameter("base_price"));
                String brand = request.getParameter("brand");
                String material = request.getParameter("material");
                int categoryId = Integer.parseInt(request.getParameter("category_id"));

                CategoryDTO category = new CategoryDTO(categoryId, "");
                Product product = new Product(0, name, description, basePrice, category, brand, material, null);

                int productId = productDAO.insertProductAndGetId(product);

                if (productId > 0) {
                    response.sendRedirect("addProductImage.jsp?product_id=" + productId);
                } else {
                    response.sendRedirect("productmanagement.jsp?error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("productmanagement.jsp?error=1");
            }
            return;
        }

        if (action.equals("insertProductImage")) {
            try {
                int productId = Integer.parseInt(request.getParameter("product_id"));
                String[] imageUrls = request.getParameterValues("image_url");

                boolean success = true;
                for (String imageUrl : imageUrls) {
                    Product product = new Product(productId);
                    ProductImages productImage = new ProductImages(0, product, imageUrl);

                    if (!productDAO.insertProductImage(productImage)) {
                        success = false;
                    }
                }

                if (success) {
                    response.sendRedirect("addProductVariant.jsp?product_id=" + productId);
                } else {
                    response.sendRedirect("productmanagement.jsp?error=1");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("productmanagement.jsp?error=1");
            }
            return;
        }

        if (action.equals("insertProductVariant")) {
            try {
                int productId = Integer.parseInt(request.getParameter("product_id"));
                String[] sizes = request.getParameterValues("sizes");
                String[] colors = request.getParameterValues("colors");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int stockQuantity = Integer.parseInt(request.getParameter("stock_quantity"));

                if (sizes == null || colors == null) {
                    response.sendRedirect("addProductVariant.jsp?error=NoSizeOrColor");
                    return;
                }

                Product product = new Product(productId);

                boolean allSuccess = true;
                for (String size : sizes) {
                    for (String color : colors) {
                        ProductVariant variant = new ProductVariant(0, product, size, color, price, stockQuantity, null);
                        int variantId = productDAO.insertProductVariant(variant);
                        if (variantId == -1) {
                            allSuccess = false;
                            continue; 
                        }

                        // Ghi log vào inventory_logs
                        InventoryLogDTO log = new InventoryLogDTO();
                        log.setVariantId(variantId);
                        log.setStockChange(stockQuantity);
                        log.setChangeType("Added");
                        log.setAdminId(adminId);
                        log.setChangeReason("Added new product variant");
                        log.setChangedAt(LocalDateTime.now());

                        if (!inventoryLogDAO.addInventoryLog(log)) {
                            allSuccess = false;
                            System.err.println("Failed to log inventory change for variant ID: " + variantId);
                        }
                    }
                }

                if (allSuccess) {
                    response.sendRedirect("ProductMgtController?action=viewVariants&productId=" + productId);
                } else {
                    response.sendRedirect("addProductVariant.jsp?error=InsertFailed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("addProductVariant.jsp?error=Exception");
            }
            return;
        } else if ("updateVariant".equals(action)) {
            try {
                String variantIdStr = request.getParameter("variantId");
                if (variantIdStr == null || variantIdStr.isEmpty()) {
                    response.sendRedirect("updateVariant.jsp?error=invalid_variant_id");
                    return;
                }
                int variantId = Integer.parseInt(variantIdStr);

                String size = request.getParameter("size");
                String color = request.getParameter("color");
                if (size == null || size.trim().isEmpty() || color == null || color.trim().isEmpty()) {
                    response.sendRedirect("updateVariant.jsp?error=invalid_data");
                    return;
                }

                String priceStr = request.getParameter("price");
                String stockQuantityStr = request.getParameter("stockQuantity");
                if (priceStr == null || stockQuantityStr == null) {
                    response.sendRedirect("updateVariant.jsp?error=missing_price_stock");
                    return;
                }

                BigDecimal price = new BigDecimal(priceStr);
                int stockQuantity = Integer.parseInt(stockQuantityStr);

                boolean updated = productDAO.updateProductVariant(variantId, size, color, price, stockQuantity);

                String productIdStr = request.getParameter("productId");
                if (productIdStr == null || productIdStr.isEmpty()) {
                    response.sendRedirect("updateVariant.jsp?error=invalid_product_id");
                    return;
                }
                int productId = Integer.parseInt(productIdStr);

                Product product = productDAO.getProductById(productId);
                if (product == null) {
                    response.sendRedirect("updateVariant.jsp?error=product_not_found");
                    return;
                }

                if (updated) {
                    response.sendRedirect("ProductMgtController?action=viewVariants&productId=" + productId);
                } else {
                    response.sendRedirect("updateVariant.jsp?updateFail=true");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("updateVariant.jsp?error=invalid_number");
            }
        } else if ("deleteVariant".equals(action)) {
            try {
                String variantIdStr = request.getParameter("variantId");
                String productIdStr = request.getParameter("productId");

                if (variantIdStr == null || variantIdStr.isEmpty() || productIdStr == null || productIdStr.isEmpty()) {
                    response.sendRedirect("productVariant.jsp?error=invalid_id");
                    return;
                }

                int variantId = Integer.parseInt(variantIdStr);
                int productId = Integer.parseInt(productIdStr);

                Product product = productDAO.getProductById(productId);
                boolean deleted = productDAO.deleteProductVariant(variantId);

                if (deleted) {
                    request.setAttribute("product", product);
                    response.sendRedirect("ProductMgtController?action=viewVariants&productId=" + productId);
                } else {
                    response.sendRedirect("productVariant.jsp?deleteFail=true");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("productVariant.jsp?error=exception");
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
