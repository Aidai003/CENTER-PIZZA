function ConvertTo-Entities($str) {
    $result = ""
    foreach ($char in $str.ToCharArray()) {
        $val = [int]$char
        if ($val -gt 127) {
            $result += "&#$val;"
        } else {
            $result += $char
        }
    }
    return $result
}

$loc = ConvertTo-Entities "Алматы, Казахстан"
$search = ConvertTo-Entities "Поиск любимых блюд..."
$piz = ConvertTo-Entities "Пицца"
$bur = ConvertTo-Entities "Бургеры"
$sus = ConvertTo-Entities "Суши"
$des = ConvertTo-Entities "Десерты"
$dri = ConvertTo-Entities "Напитки"
$pop = ConvertTo-Entities "Популярное сегодня"
$all = ConvertTo-Entities "См. все"
$rb = ConvertTo-Entities "Королевский Бургер"
$rbd = ConvertTo-Entities "Сочная говядина, чеддер, фирменный соус"
$mp = ConvertTo-Entities "Маргарита Премиум"
$mpd = ConvertTo-Entities "Свежие томаты, моцарелла, базилик"
$st = ConvertTo-Entities "Сет `"Токио`""
$std = ConvertTo-Entities "Лосось, тунец, авокадо, 16 шт."
$cf = ConvertTo-Entities "Шоколадный Фондан"
$cfd = ConvertTo-Entities "Теплый шоколад с малиновым соусом"

$pizzaBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes('assets/pizza.png'))
$burgerBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes('assets/burger.png'))
$sushiBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes('assets/sushi.png'))
$dessertBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes('assets/dessert.png'))
$cocktailBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes('assets/cocktail.png'))

$template = @'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gourmet Go</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        :root {
            --bg-color: #020617;
            --card-bg: #1e293b;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent: #f97316;
            --accent-hover: #ea580c;
            --rating-color: #fbbf24;
            --nav-bg: rgba(30, 41, 59, 0.6);
            --border-radius-lg: 24px;
            --border-radius-md: 16px;
            --story-gradient: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
        body { font-family: 'Outfit', sans-serif; background-color: var(--bg-color); color: var(--text-primary); overflow-x: hidden; }
        .app-container { max-width: 480px; margin: 0 auto; min-height: 100vh; padding-bottom: 90px; }
        .header { padding: 24px 20px 16px; background: linear-gradient(to bottom, var(--bg-color), rgba(2, 6, 23, 0.8)); position: sticky; top: 0; z-index: 100; }
        .header-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .location { display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 600; }
        .location i { color: var(--accent); width: 18px; }
        .user-profile img { width: 40px; height: 40px; border-radius: 50%; border: 2px solid var(--accent); }
        .search-bar { background-color: var(--card-bg); border-radius: var(--border-radius-md); padding: 12px 16px; display: flex; align-items: center; gap: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3); }
        .search-bar i { color: var(--text-secondary); width: 20px; }
        .search-bar input { background: none; border: none; color: var(--text-primary); width: 100%; font-size: 15px; outline: none; }
        .stories-container { display: flex; gap: 16px; padding: 10px 20px 20px; overflow-x: auto; scrollbar-width: none; scroll-snap-type: x mandatory; }
        .stories-container::-webkit-scrollbar { display: none; }
        .story-item { display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; flex-shrink: 0; scroll-snap-align: start; }
        .story-ring { width: 76px; height: 76px; padding: 3px; border-radius: 50%; background: var(--story-gradient); display: flex; justify-content: center; align-items: center; transition: transform 0.2s ease; }
        .story-ring img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; border: 3px solid var(--bg-color); }
        .story-item span { font-size: 12px; font-weight: 500; color: var(--text-secondary); }
        .content { padding: 0 20px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .section-header h2 { font-size: 20px; font-weight: 700; }
        .section-header a { font-size: 14px; color: var(--accent); text-decoration: none; font-weight: 600; }
        .menu-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
        .menu-card { background-color: var(--card-bg); border-radius: var(--border-radius-lg); overflow: hidden; transition: transform 0.3s ease; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.4); }
        .card-image { position: relative; height: 140px; }
        .card-image img { width: 100%; height: 100%; object-fit: cover; }
        .rating { position: absolute; top: 10px; left: 10px; background: rgba(0, 0, 0, 0.6); backdrop-filter: blur(4px); padding: 4px 8px; border-radius: 20px; font-size: 11px; font-weight: 700; display: flex; align-items: center; gap: 4px; color: var(--rating-color); }
        .rating i { width: 12px; fill: var(--rating-color); }
        .favorite-btn { position: absolute; top: 10px; right: 10px; background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(4px); border: none; width: 32px; height: 32px; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: white; }
        .card-info { padding: 12px; }
        .card-info h3 { font-size: 15px; font-weight: 600; margin-bottom: 4px; }
        .card-info p { font-size: 12px; color: var(--text-secondary); margin-bottom: 12px; line-height: 1.4; height: 34px; overflow: hidden; }
        .card-footer { display: flex; justify-content: space-between; align-items: center; }
        .price { font-size: 16px; font-weight: 700; color: var(--accent); }
        .add-btn { background-color: var(--accent); color: white; border: none; width: 32px; height: 32px; border-radius: 10px; display: flex; justify-content: center; align-items: center; }
        .bottom-nav { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); width: calc(100% - 40px); max-width: 440px; background: var(--nav-bg); backdrop-filter: blur(20px); height: 64px; border-radius: 32px; display: flex; justify-content: space-around; align-items: center; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5); border: 1px solid rgba(255, 255, 255, 0.05); z-index: 1000; }
        .nav-item { color: var(--text-secondary); text-decoration: none; position: relative; padding: 8px; }
        .nav-item.active { color: var(--accent); }
        .cart-item .badge { position: absolute; top: 0; right: 0; background-color: var(--accent); color: white; font-size: 10px; font-weight: 700; width: 18px; height: 18px; border-radius: 50%; display: flex; justify-content: center; align-items: center; border: 2px solid var(--bg-color); }
    </style>
</head>
<body>
    <div class="app-container">
        <header class="header">
            <div class="header-top">
                <div class="location"><i data-lucide="map-pin"></i><span>[[LOC]]</span></div>
                <div class="user-profile"><img src="https://ui-avatars.com/api/?name=User&background=f97316&color=fff" alt="User"></div>
            </div>
            <div class="search-bar"><i data-lucide="search"></i><input type="text" placeholder="[[SEARCH]]"></div>
        </header>
        <section class="stories-container">
            <div class="story-item"><div class="story-ring"><img src="data:image/png;base64,[[PIZZA]]" alt="Pizza"></div><span>[[PIZ]]</span></div>
            <div class="story-item"><div class="story-ring"><img src="data:image/png;base64,[[BURGER]]" alt="Burger"></div><span>[[BUR]]</span></div>
            <div class="story-item"><div class="story-ring"><img src="data:image/png;base64,[[SUSHI]]" alt="Sushi"></div><span>[[SUS]]</span></div>
            <div class="story-item"><div class="story-ring"><img src="data:image/png;base64,[[DESSERT]]" alt="Dessert"></div><span>[[DES]]</span></div>
            <div class="story-item"><div class="story-ring"><img src="data:image/png;base64,[[COCKTAIL]]" alt="Cocktail"></div><span>[[DRI]]</span></div>
        </section>
        <main class="content">
            <div class="section-header"><h2>[[POP]]</h2><a href="#">[[ALL]]</a></div>
            <div class="menu-grid">
                <div class="menu-card">
                    <div class="card-image"><img src="data:image/png;base64,[[BURGER]]" alt="Royal Burger"><span class="rating"><i data-lucide="star"></i> 4.8</span><button class="favorite-btn"><i data-lucide="heart"></i></button></div>
                    <div class="card-info"><h3>[[RB]]</h3><p>[[RBD]]</p><div class="card-footer"><span class="price">2 450 ₸</span><button class="add-btn"><i data-lucide="plus"></i></button></div></div>
                </div>
                <div class="menu-card">
                    <div class="card-image"><img src="data:image/png;base64,[[PIZZA]]" alt="Margherita"><span class="rating"><i data-lucide="star"></i> 4.9</span><button class="favorite-btn"><i data-lucide="heart"></i></button></div>
                    <div class="card-info"><h3>[[MP]]</h3><p>[[MPD]]</p><div class="card-footer"><span class="price">3 100 ₸</span><button class="add-btn"><i data-lucide="plus"></i></button></div></div>
                </div>
                <div class="menu-card">
                    <div class="card-image"><img src="data:image/png;base64,[[SUSHI]]" alt="Sushi Set"><span class="rating"><i data-lucide="star"></i> 4.7</span><button class="favorite-btn"><i data-lucide="heart"></i></button></div>
                    <div class="card-info"><h3>[[ST]]</h3><p>[[STD]]</p><div class="card-footer"><span class="price">5 800 ₸</span><button class="add-btn"><i data-lucide="plus"></i></button></div></div>
                </div>
                <div class="menu-card">
                    <div class="card-image"><img src="data:image/png;base64,[[DESSERT]]" alt="Choco Lava"><span class="rating"><i data-lucide="star"></i> 4.9</span><button class="favorite-btn"><i data-lucide="heart"></i></button></div>
                    <div class="card-info"><h3>[[CF]]</h3><p>[[CFD]]</p><div class="card-footer"><span class="price">1 850 ₸</span><button class="add-btn"><i data-lucide="plus"></i></button></div></div>
                </div>
            </div>
        </main>
        <nav class="bottom-nav">
            <a href="#" class="nav-item active"><i data-lucide="home"></i></a>
            <a href="#" class="nav-item"><i data-lucide="search"></i></a>
            <a href="#" class="nav-item cart-item"><i data-lucide="shopping-bag"></i><span class="badge">2</span></a>
            <a href="#" class="nav-item"><i data-lucide="heart"></i></a>
            <a href="#" class="nav-item"><i data-lucide="user"></i></a>
        </nav>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            lucide.createIcons();
            const addButtons = document.querySelectorAll('.add-btn');
            const cartBadge = document.querySelector('.cart-item .badge');
            addButtons.forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    let count = parseInt(cartBadge.innerText);
                    cartBadge.innerText = count + 1;
                    const originalIcon = btn.innerHTML;
                    btn.innerHTML = '<i data-lucide="check"></i>';
                    lucide.createIcons();
                    setTimeout(() => { btn.innerHTML = originalIcon; lucide.createIcons(); }, 1000);
                });
            });
        });
    </script>
</body>
</html>
'@

$html = $template.Replace('[[LOC]]', $loc) `
    .Replace('[[SEARCH]]', $search) `
    .Replace('[[PIZ]]', $piz) `
    .Replace('[[BUR]]', $bur) `
    .Replace('[[SUS]]', $sus) `
    .Replace('[[DES]]', $des) `
    .Replace('[[DRI]]', $dri) `
    .Replace('[[POP]]', $pop) `
    .Replace('[[ALL]]', $all) `
    .Replace('[[RB]]', $rb) `
    .Replace('[[RBD]]', $rbd) `
    .Replace('[[MP]]', $mp) `
    .Replace('[[MPD]]', $mpd) `
    .Replace('[[ST]]', $st) `
    .Replace('[[STD]]', $std) `
    .Replace('[[CF]]', $cf) `
    .Replace('[[CFD]]', $cfd) `
    .Replace('[[PIZZA]]', $pizzaBase64) `
    .Replace('[[BURGER]]', $burgerBase64) `
    .Replace('[[SUSHI]]', $sushiBase64) `
    .Replace('[[DESSERT]]', $dessertBase64) `
    .Replace('[[COCKTAIL]]', $cocktailBase64)

[IO.File]::WriteAllText("$PSScriptRoot/index.html", $html, [System.Text.Encoding]::ASCII)
