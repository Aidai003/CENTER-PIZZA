document.addEventListener('DOMContentLoaded', () => {
    // Favorite button toggle
    const favoriteButtons = document.querySelectorAll('.favorite-btn');
    favoriteButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            const icon = btn.querySelector('i');
            if (icon.getAttribute('data-lucide') === 'heart') {
                const isFill = btn.style.fill === 'var(--accent)';
                btn.style.color = isFill ? 'white' : 'var(--accent)';
                btn.style.fill = isFill ? 'none' : 'var(--accent)';
            }
        });
    });

    // Add to cart interaction
    const addButtons = document.querySelectorAll('.add-btn');
    const cartBadge = document.querySelector('.cart-item .badge');
    
    addButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            // Simple animation
            btn.style.transform = 'scale(0.8)';
            setTimeout(() => {
                btn.style.transform = 'scale(1)';
            }, 100);

            // Increment badge
            let count = parseInt(cartBadge.innerText);
            cartBadge.innerText = count + 1;

            // Visual feedback
            const originalIcon = btn.innerHTML;
            btn.innerHTML = '<i data-lucide="check"></i>';
            lucide.createIcons();
            
            setTimeout(() => {
                btn.innerHTML = originalIcon;
                lucide.createIcons();
            }, 1000);
        });
    });

    // Story click effect
    window.filterCategory = (category) => {
        console.log(`Filtering by ${category}`);
        // Add active state to story
        const stories = document.querySelectorAll('.story-item');
        stories.forEach(story => {
            story.style.opacity = '0.6';
        });
        
        // Find the clicked story (event based would be better but this works for demo)
        const clickedStory = document.querySelector(`.story-item[onclick*="${category}"]`);
        if (clickedStory) clickedStory.style.opacity = '1';

        // In a real app, we would filter the menu items here
    };

    // Nav item switching
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.addEventListener('click', (e) => {
            if (!item.classList.contains('cart-item')) {
                navItems.forEach(n => n.classList.remove('active'));
                item.classList.add('active');
            }
        });
    });
});
