/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Category;

import java.time.LocalDateTime;

/**
 *
 * @author nguye
 */
public class CategoryDTO {
    private int categoryId;
    private String name;
    private String description;
    private LocalDateTime createdAt;
    private String imageUrl;
    
    public CategoryDTO(){
        
    }
    
    public CategoryDTO(int categoryId, String name) {
        this.categoryId = categoryId;
        this.name = name;
    }

    public CategoryDTO(int categoryId, String name, String description, LocalDateTime createdAt, String imageUrl) {
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
        this.imageUrl = imageUrl;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
   
}
