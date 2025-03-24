package controller;

import OFS.Product.Product;
import OFS.Product.ProductDAO;
import OFS.Product.ProductImages;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/search")
public class SearchController extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("query");
        List<Product> products = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            try {
                products = productDAO.searchProductsByName(query);
                for (Product product : products) {
                    List<ProductImages> images = productDAO.getProductImagesByProductId(product.getProductId());
                    if (!images.isEmpty()) {
                        request.setAttribute("firstImage_" + product.getProductId(), images.get(0).getImageUrl());
                    } else {
                        request.setAttribute("firstImage_" + product.getProductId(), request.getContextPath() + "/Images/default.jpg");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tìm kiếm sản phẩm: " + e.getMessage());
                products = new ArrayList<>(); 
            }
        } else {
            try {
                products = productDAO.getLatestProducts();
                for (Product product : products) {
                    List<ProductImages> images = productDAO.getProductImagesByProductId(product.getProductId());
                    if (!images.isEmpty()) {
                        request.setAttribute("firstImage_" + product.getProductId(), images.get(0).getImageUrl());
                    } else {
                        request.setAttribute("firstImage_" + product.getProductId(), request.getContextPath() + "/Images/default.jpg");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Không thể lấy danh sách sản phẩm mới nhất: " + e.getMessage());
                products = new ArrayList<>(); 
            }
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("/home?openOverlay=true").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
