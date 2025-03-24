/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Wishlist;

import OFS.Product.Product;
import OFS.Users.UsersDTO;
import java.time.LocalDateTime;

/**
 *
 * @author nguye
 */
public class WishlistDTO {
    private int wishlistId;
    private UsersDTO user;
    private Product product;
    private LocalDateTime addedAt;
    
    public WishlistDTO(){
        
    }

    public WishlistDTO(int wishlistId, UsersDTO user, Product product, LocalDateTime addedAt) {
        this.wishlistId = wishlistId;
        this.user = user;
        this.product = product;
        this.addedAt = addedAt;
    }

    public int getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(int wishlistId) {
        this.wishlistId = wishlistId;
    }

    public UsersDTO getUser() {
        return user;
    }

    public void setUser(UsersDTO user) {
        this.user = user;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public LocalDateTime getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }
    
    
}
