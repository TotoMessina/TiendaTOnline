// CONFIGURACIÓN DE SUPABASE
// REEMPLAZA ESTOS VALORES CON TUS CREDENCIALES REALES
const SUPABASE_URL = 'https://eeltuofcdqekccypwykm.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlbHR1b2ZjZHFla2NjeXB3eWttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE0MDU2MDAsImV4cCI6MjA4Njk4MTYwMH0.n9viYMxD4JbtPZNLs6TdfRuWQfmPhgX5MsZ4y3hG7RY';

// Inicializar cliente de Supabase
// Usamos 'supabaseClient' para evitar conflicto con la variable global 'supabase' del CDN
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

// Elementos del DOM
const navList = document.querySelector('.nav-list');
const productGrid = document.querySelector('.product-grid');
const loadingMessage = '<p style="text-align:center; width:100%;">Cargando productos...</p>';

// Menú Hamburguesa Logic
const menuToggle = document.querySelector('.menu-toggle');
const nav = document.querySelector('.nav');
const navOverlay = document.querySelector('.nav-overlay');

function toggleMenu() {
    nav.classList.toggle('active');
    navOverlay.classList.toggle('active');
    document.body.style.overflow = nav.classList.contains('active') ? 'hidden' : ''; // Prevent body scroll
}

function closeMenu() {
    nav.classList.remove('active');
    navOverlay.classList.remove('active');
    document.body.style.overflow = '';
}

if (menuToggle) {
    menuToggle.addEventListener('click', toggleMenu);
    navOverlay.addEventListener('click', closeMenu);
}

// Estado de la aplicación
let allProducts = [];
let currentCategory = 'all';
let cart = []; // Array de {product, quantity}

// Función principal de carga
async function initApp() {
    console.log('Iniciando aplicación...');

    // Mostrar estado de carga inicial
    productGrid.innerHTML = loadingMessage;

    setupSearchListeners(); // Configurar buscadores
    setupCartListeners();   // Configurar carrito

    try {
        await Promise.all([
            fetchCategories(),
            fetchProducts()
        ]);

        console.log('Datos cargados exitosamente');
    } catch (error) {
        console.error('Error al inicializar la app:', error);
        productGrid.innerHTML = '<p style="text-align:center; color:red;">Error al cargar los datos. Por favor revisa la consola.</p>';
    }
}

// Configurar Listeners de Carrito
function setupCartListeners() {
    const cartToggle = document.querySelector('.cart-toggle');
    const cartClose = document.querySelector('.cart-close');
    const cartOverlay = document.querySelector('.cart-overlay');
    const checkoutBtn = document.querySelector('.btn-checkout');

    if (cartToggle) cartToggle.addEventListener('click', () => toggleCart(true));
    if (cartClose) cartClose.addEventListener('click', () => toggleCart(false));
    if (cartOverlay) cartOverlay.addEventListener('click', () => toggleCart(false));
    if (checkoutBtn) checkoutBtn.addEventListener('click', checkoutWhatsApp);
}

function toggleCart(open) {
    const cartDrawer = document.querySelector('.cart-drawer');
    const cartOverlay = document.querySelector('.cart-overlay');
    if (open) {
        cartDrawer.classList.add('active');
        cartOverlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    } else {
        cartDrawer.classList.remove('active');
        cartOverlay.classList.remove('active');
        document.body.style.overflow = '';
    }
}

// Configurar Listeners de Búsqueda
function setupSearchListeners() {
    // 1. Buscador de Categorías (Menu)
    const categorySearch = document.getElementById('category-search');
    if (categorySearch) {
        categorySearch.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            const links = document.querySelectorAll('.nav-link');

            links.forEach(link => {
                // Skip "Todo" link/li if you want, or include it. 
                // Usually we filter the parent <li>
                const listItem = link.parentElement;
                const text = link.textContent.toLowerCase();

                if (text.includes(term)) {
                    listItem.style.display = '';
                } else {
                    listItem.style.display = 'none';
                }
            });
        });
    }

    // 2. Buscador de Productos (Main)
    const productSearch = document.getElementById('product-search');
    if (productSearch) {
        productSearch.addEventListener('input', () => {
            filterAndRenderProducts();
        });
    }
}

// Obtener Categorías
async function fetchCategories() {
    const { data, error } = await supabaseClient
        .from('categorias')
        .select('*');

    if (error) {
        console.error('Error obteniendo categorías:', error);
        return;
    }

    renderCategories(data);
}

// Renderizar Menú de Categorías
function renderCategories(categories) {
    // Limpiar menú (manteniendo "Todo" si se desea, aquí lo reconstruimos completo)
    const allOption = `<li><a href="#" class="nav-link active" data-id="all">Todo</a></li>`;

    const categoryOptions = categories.map(cat => `
        <li>
            <a href="#" class="nav-link" data-id="${cat.id}">${cat.nombre}</a>
        </li>
    `).join('');

    navList.innerHTML = allOption + categoryOptions;

    // Agregar Listeners
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            handleCategoryClick(e.target);
            closeMenu(); // Cerrar menú al seleccionar
        });
    });
}

// Manejar Clic en Categoría
function handleCategoryClick(clickedElement) {
    // Actualizar UI activa
    document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
    clickedElement.classList.add('active');

    // Filtrar productos
    const categoryId = clickedElement.getAttribute('data-id');
    currentCategory = categoryId;

    filterAndRenderProducts();
}

// Obtener Productos (con Join simple si es necesario, o traer todo y filtrar en cliente para catálogos pequeños)
async function fetchProducts() {
    // Asumimos que la tabla productos tiene foreign key 'categoria_id'
    const { data, error } = await supabaseClient
        .from('productos')
        .select(`
            *,
            categorias (
                nombre
            )
        `);

    if (error) {
        console.error('Error obteniendo productos:', error);
        throw error;
    }

    allProducts = data;
    console.log(`Cargados ${allProducts.length} productos.`);
    filterAndRenderProducts();
}

// Filtrar y Renderizar Productos
function filterAndRenderProducts() {
    let filteredProducts = allProducts;

    if (currentCategory !== 'all') {
        filteredProducts = allProducts.filter(product => product.categoria_id == currentCategory);
    }

    // Apply product search filter if active
    const productSearch = document.getElementById('product-search');
    if (productSearch && productSearch.value) {
        const term = productSearch.value.toLowerCase();
        filteredProducts = filteredProducts.filter(product => product.nombre.toLowerCase().includes(term));
    }

    renderProducts(filteredProducts);
}

// Actualizar Render Productos para Botón Agregar
function renderProducts(products) {
    productGrid.innerHTML = '';

    if (products.length === 0) {
        productGrid.innerHTML = '<p style="text-align:center; width:100%;">No se encontraron productos en esta categoría.</p>';
        return;
    }

    const productsHTML = products.map(product => {
        // Generar iniciales (Ej: "Smart Watch" -> "SW")
        const initials = product.nombre
            .split(' ')
            .map(word => word[0])
            .join('')
            .substring(0, 2)
            .toUpperCase();

        return `
        <article class="product-card">
            <div class="product-header">
                <div class="product-initials">${initials}</div>
            </div>
            <div class="product-content">
                <h2 class="product-title">${product.nombre}</h2>
                <div class="product-description">
                    ${product.descripcion || 'Sin descripción disponible.'}
                </div>
                <p class="product-price">$${formatPrice(product.precio)}</p>
            </div>
            <button class="btn-primary" onclick="addToCart('${product.id}')">Agregar al Carrito</button>
        </article>
        `;
    }).join('');

    productGrid.innerHTML = productsHTML;
}

// Lógica del Carrito
function addToCart(productId) {
    // productId podría venir como string o number, asegurarse de comparar bien
    const product = allProducts.find(p => p.id == productId);

    if (!product) return;

    const existingItem = cart.find(item => item.product.id == productId);

    if (existingItem) {
        existingItem.quantity++;
    } else {
        cart.push({ product: product, quantity: 1 });
    }

    updateCartUI();
    toggleCart(true); // Abrir carrito al agregar para feedback inmediato
}

function removeFromCart(productId) {
    cart = cart.filter(item => item.product.id != productId);
    updateCartUI();
}

function changeQuantity(productId, delta) {
    const item = cart.find(item => item.product.id == productId);
    if (item) {
        item.quantity += delta;
        if (item.quantity <= 0) {
            removeFromCart(productId);
        } else {
            updateCartUI();
        }
    }
}

function updateCartUI() {
    const cartItemsContainer = document.querySelector('.cart-items');
    const cartCountBadge = document.querySelector('.cart-count');
    const totalPriceEl = document.querySelector('.total-price');

    // Actualizar Badge
    const totalCount = cart.reduce((sum, item) => sum + item.quantity, 0);
    cartCountBadge.textContent = totalCount;

    // Calcular Total
    const total = cart.reduce((sum, item) => sum + (item.product.precio * item.quantity), 0);
    totalPriceEl.textContent = `$${formatPrice(total)}`;

    // Renderizar Items
    if (cart.length === 0) {
        cartItemsContainer.innerHTML = '<p class="empty-cart-msg">Tu carrito está vacío.</p>';
        return;
    }

    cartItemsContainer.innerHTML = cart.map(item => `
        <div class="cart-item">
            <img src="${item.product.imagen_url || 'https://placehold.co/100x100?text=Prod'}" alt="${item.product.nombre}">
            <div class="cart-item-info">
                <div class="cart-item-title">${item.product.nombre}</div>
                <div class="cart-item-price">$${formatPrice(item.product.precio * item.quantity)}</div>
            </div>
            <div class="cart-item-controls">
                <button class="btn-qty" onclick="changeQuantity('${item.product.id}', -1)">-</button>
                <span>${item.quantity}</span>
                <button class="btn-qty" onclick="changeQuantity('${item.product.id}', 1)">+</button>
            </div>
        </div>
    `).join('');
}

// Checkout WhatsApp
function checkoutWhatsApp() {
    if (cart.length === 0) return alert('El carrito está vacío');

    // Asegúrate de poner el número con el código de país sin + (ej: 54911...)
    const phone = '5491127672972';
    let message = 'Hola! Quiero realizar el siguiente pedido:\n\n';

    cart.forEach(item => {
        message += `- ${item.product.nombre} (x${item.quantity}): $${formatPrice(item.product.precio * item.quantity)}\n`;
    });

    const total = cart.reduce((sum, item) => sum + (item.product.precio * item.quantity), 0);
    message += `\n*Total: $${formatPrice(total)}*`;

    const url = `https://wa.me/${phone}?text=${encodeURIComponent(message)}`;
    window.open(url, '_blank');
}

// Helper para formato de moneda (asumiendo input numérico)
function formatPrice(price) {
    return Number(price).toFixed(2);
}

// Iniciar
document.addEventListener('DOMContentLoaded', initApp);
