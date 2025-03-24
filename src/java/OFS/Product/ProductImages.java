/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Product;

/**
 *
 * @author nguye
 */
public class ProductImages {
    private int productImageId;
    private Product product;
    private String imageUrl;
    
    public ProductImages(){
        
    }

    public ProductImages(int productImageId, Product product, String imageUrl) {
        this.productImageId = productImageId;
        this.product = product;
        this.imageUrl = imageUrl;
    }
    
    public ProductImages(String imageUrl) {  
        this.imageUrl = imageUrl;
    }

    public int getProductImageId() {
        return productImageId;
    }

    public void setProductImageId(int productImageId) {
        this.productImageId = productImageId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    
}
