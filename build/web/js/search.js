function openSearch() {
    const searchOverlay = document.getElementById('searchOverlay');
    if (searchOverlay) {
        console.log('Opening search overlay'); // Debug
        searchOverlay.classList.add('active'); // Thêm class 'active'
        sessionStorage.setItem('searchOverlayOpen', 'true'); // Lưu trạng thái mở vào sessionStorage
    } else {
        console.error('searchOverlay element not found');
    }
}

function closeSearch() {
    const searchOverlay = document.getElementById('searchOverlay');
    if (searchOverlay) {
        console.log('Closing search overlay'); // Debug
        searchOverlay.classList.remove('active'); // Xóa class 'active'
        sessionStorage.setItem('searchOverlayOpen', 'false'); // Lưu trạng thái đóng vào sessionStorage
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const searchOverlay = document.getElementById('searchOverlay');
    if (!searchOverlay) {
        console.error('searchOverlay element not found on page load');
        return;
    }

    // Kiểm tra trạng thái trong sessionStorage
    const isOverlayOpen = sessionStorage.getItem('searchOverlayOpen') === 'true';
    console.log('Overlay open state from sessionStorage:', isOverlayOpen); // Debug

    // Kiểm tra biến window.shouldOpenOverlay từ JSP
    const shouldOpenOverlay = window.shouldOpenOverlay === true;
    console.log('shouldOpenOverlay from JSP:', shouldOpenOverlay); // Debug

    // Mở overlay nếu trạng thái trong sessionStorage là true hoặc JSP yêu cầu mở
    if (isOverlayOpen || shouldOpenOverlay) {
        openSearch();
    }

    // Khởi tạo trạng thái wishlist khi tải trang
    const wishlistIcons = document.querySelectorAll('.wishlist-icon');
    console.log('Number of wishlist icons found:', wishlistIcons.length); // Debug
    wishlistIcons.forEach(icon => {
        const productId = icon.getAttribute('data-product-id');
        if (productId) {
            const isWishlisted = localStorage.getItem(`wishlist_${productId}`) === 'true';
            console.log(`Product ${productId} wishlisted:`, isWishlisted); // Debug
            if (isWishlisted) {
                icon.classList.add('active'); // Thêm class active cho span
            }
        } else {
            console.error('Product ID not found for wishlist icon:', icon);
        }
    });
});

function clearSearchInput() {
    const searchInput = document.getElementById("searchInput");
    if (searchInput) {
        searchInput.value = "";
    }
    // Tải lại trang để hiển thị 4 sản phẩm mới nhất, giữ trạng thái overlay
    sessionStorage.setItem('searchOverlayOpen', 'true'); // Đảm bảo trạng thái mở được giữ
    window.location.href = window.location.pathname;
}

// Thêm sự kiện beforeunload để xóa trạng thái khi đóng tab
window.addEventListener('beforeunload', function() {
    // Xóa trạng thái searchOverlayOpen khi đóng tab
    sessionStorage.removeItem('searchOverlayOpen');
});

// Hàm xử lý sự kiện nhấp vào icon trái tim
function toggleWishlist(productId, element) {
    if (!productId) {
        console.error('Product ID is undefined');
        return;
    }
    const isWishlisted = localStorage.getItem(`wishlist_${productId}`) === 'true';
    console.log(`Toggling wishlist for product ${productId}, current state:`, isWishlisted); // Debug
    if (isWishlisted) {
        // Nếu đã được thêm vào wishlist, xóa khỏi wishlist
        localStorage.setItem(`wishlist_${productId}`, 'false');
        element.classList.remove('active'); // Xóa class active để trở lại viền đen
    } else {
        // Nếu chưa được thêm vào wishlist, thêm vào wishlist
        localStorage.setItem(`wishlist_${productId}`, 'true');
        element.classList.add('active'); // Thêm class active để hiển thị màu đỏ
    }
}