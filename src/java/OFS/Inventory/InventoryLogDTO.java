/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Inventory;

import java.time.LocalDateTime;

/**
 *
 * @author nguye
 */
public class InventoryLogDTO {
    private int logId;
    private int variantId;
    private int stockChange;
    private String changeType;
    private int adminId;
    private String changeReason;
    private LocalDateTime changedAt;
    
    public InventoryLogDTO(){
        
    }

    public InventoryLogDTO(int logId, int variantId, int stockChange, String changeType, int adminId, String changeReason, LocalDateTime changedAt) {
        this.logId = logId;
        this.variantId = variantId;
        this.stockChange = stockChange;
        this.changeType = changeType;
        this.adminId = adminId;
        this.changeReason = changeReason;
        this.changedAt = changedAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getStockChange() {
        return stockChange;
    }

    public void setStockChange(int stockChange) {
        this.stockChange = stockChange;
    }

    public String getChangeType() {
        return changeType;
    }

    public void setChangeType(String changeType) {
        this.changeType = changeType;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getChangeReason() {
        return changeReason;
    }

    public void setChangeReason(String changeReason) {
        this.changeReason = changeReason;
    }

    public LocalDateTime getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(LocalDateTime changedAt) {
        this.changedAt = changedAt;
    }
    
    
}
