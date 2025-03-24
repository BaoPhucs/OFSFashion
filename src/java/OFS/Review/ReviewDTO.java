/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Review;

import OFS.Product.Product;
import OFS.Users.UsersDTO;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author nguye
 */
public class ReviewDTO {
    private int reviewId;
    private UsersDTO user;
    private Product product;
    private int rating;
    private String comment;
    private LocalDateTime createdAt;
    
    public ReviewDTO(){
        
    }

    public ReviewDTO(int reviewId, UsersDTO userId, Product product, int rating, String comment, LocalDateTime createdAt) {
        this.reviewId = reviewId;
        this.user = user;
        this.product = product;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
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

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public String format(String pattern) {
        if (createdAt == null) {
            return "Unknown Date";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
        return createdAt.format(formatter);
    }
}
