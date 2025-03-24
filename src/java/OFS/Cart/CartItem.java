package OFS.Cart;

import OFS.Product.Product;
import OFS.Product.ProductVariant;
import java.math.BigDecimal;

public class CartItem implements Cloneable {
    private int index; // Chỉ số của item trong giỏ hàng (nếu cần)
    private Product product;
    private ProductVariant variant;
    private int quantity;

    public CartItem() {};
    // Constructor
    public CartItem(Product product, ProductVariant variant, int quantity) {
        this.product = product;
        this.variant = variant;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        return variant.getPrice().multiply(BigDecimal.valueOf(quantity));
    }

    // Override clone() method
    @Override
    public CartItem clone() throws CloneNotSupportedException {
        CartItem cloned = (CartItem) super.clone();
        // Sao chép sâu nếu cần (nếu Product hoặc ProductVariant cần sao chép sâu)
        // Hiện tại giả định Product và ProductVariant không cần sao chép sâu
        return cloned;
    }
}