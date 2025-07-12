#!/usr/bin/env bash

set -e

echo "Création de la structure du projet Astro + Tailwind…"

# Root files
cat > package.json << 'EOF'
{
  "name": "erreplus-site",
  "version": "1.0.0",
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview"
  },
  "dependencies": {
    "astro": "^3.0.0",
    "tailwindcss": "^3.2.0",
    "@astrojs/tailwind": "^4.0.0",
    "@astrojs/image": "^3.0.0"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
EOF

cat > astro.config.mjs << 'EOF'
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
export default defineConfig({
  integrations: [tailwind()],
  site: 'https://erreplus.local'
});
EOF

cat > tailwind.config.cjs << 'EOF'
module.exports = {
  content: ['./src/**/*.{astro,html,js,jsx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: '#7C4DFF',
        secondary: '#FFD54F'
      }
    }
  },
  plugins: []
};
EOF

# Directories
mkdir -p src/{components,pages,data} public/images

# Data
cat > src/data/saddles.json << 'EOF'
[
  {
    "name": "Concept DR",
    "description": "Monocast, ajustable, parfait pour dressage.",
    "image": "/images/saddle1.jpg"
  },
  {
    "name": "Concept SJ",
    "description": "Pour saut, équilibré et léger.",
    "image": "/images/saddle2.jpg"
  },
  {
    "name": "Eventing Pro",
    "description": "Robuste, pour cross et endurance.",
    "image": "/images/saddle3.jpg"
  }
]
EOF

# Components
cat > src/components/Layout.astro << 'EOF'
--- 
const { title } = Astro.props;
import Header from './Header.astro';
import Footer from './Footer.astro';
---
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <title>{title} – Erreplus</title>
    <link rel="stylesheet" href="/global.css" />
  </head>
  <body class="flex flex-col min-h-screen">
    <Header />
    <main class="flex-grow">{Astro.slots.default()}</main>
    <Footer />
  </body>
</html>
EOF

cat > src/components/Header.astro << 'EOF'
<header class="bg-primary text-white">
  <div class="container mx-auto flex justify-between items-center p-4">
    <img src="/images/logo.png" alt="Erreplus logo" class="h-12" />
    <nav class="space-x-4">
      <a href="/" class="hover:underline">Accueil</a>
      <a href="/about" class="hover:underline">À propos</a>
      <a href="/saddles" class="hover:underline">Selles</a>
      <a href="/customization" class="hover:underline">Personnalisation</a>
      <a href="/events" class="hover:underline">Événements</a>
      <a href="/contact" class="hover:underline">Contact</a>
    </nav>
  </div>
</header>
EOF

cat > src/components/Footer.astro << 'EOF'
<footer class="bg-gray-800 text-white py-6">
  <div class="container mx-auto text-center">
    &copy; {new Date().getFullYear()} Erreplus Suisse Romande. Tous droits réservés.
  </div>
</footer>
EOF

cat > src/components/Hero.astro << 'EOF'
--- 
const { title, subtitle, image, ctaText, ctaHref } = Astro.props;
---
<section class="relative bg-cover bg-center h-96" style={`background-image: url('${image}')`}>
  <div class="absolute inset-0 bg-black bg-opacity-50 flex flex-col justify-center items-center text-white">
    <h1 class="text-4xl font-bold mb-4">{title}</h1>
    <p class="mb-6">{subtitle}</p>
    {ctaText && ctaHref && (
      <a href={ctaHref} class="bg-secondary text-primary font-bold py-2 px-4 rounded">{ctaText}</a>
    )}
  </div>
</section>
EOF

cat > src/components/SaddleCard.astro << 'EOF'
--- 
const { saddle } = Astro.props;
---
<article class="bg-white shadow-md rounded overflow-hidden">
  <img src={saddle.image} alt={saddle.name} class="w-full h-48 object-cover" />
  <div class="p-4">
    <h3 class="font-bold text-lg">{saddle.name}</h3>
    <p class="text-gray-600">{saddle.description}</p>
  </div>
</article>
EOF

cat > src/components/ContactForm.astro << 'EOF'
<form action="https://formspree.io/f/YOUR_FORM_ID" method="POST" class="space-y-4 max-w-lg mx-auto p-4">
  <input type="text" name="name" placeholder="Nom" required class="w-full border rounded p-2" />
  <input type="email" name="_replyto" placeholder="Email" required class="w-full border rounded p-2" />
  <textarea name="message" placeholder="Message" required class="w-full border rounded p-2"></textarea>
  <button type="submit" class="bg-primary text-white px-4 py-2 rounded">Envoyer</button>
</form>
EOF

cat > src/components/Testimonial.astro << 'EOF'
--- 
const { author, text } = Astro.props;
---
<div class="bg-gray-100 p-4 rounded shadow">
  <p class="italic">"{text}"</p>
  <p class="text-right mt-2 font-bold">— {author}</p>
</div>
EOF

# Pages
cat > src/pages/index.astro << 'EOF'
--- 
import Layout from '../components/Layout.astro';
import Hero from '../components/Hero.astro';
import SaddleCard from '../components/SaddleCard.astro';
import saddles from '../data/saddles.json';
---
<Layout title="Accueil">
  <Hero
    title="Selles artisanales made in Italy"
    subtitle="Fabrication Valdagno – Cuir taureau haut de gamme"
    image="/images/hero.jpg"
    ctaText="Découvrir nos modèles"
    ctaHref="/saddles"
  />
  <section class="container mx-auto py-12">
    <h2 class="text-2xl font-bold mb-6 text-center">Nos modèles phares</h2>
    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
      {saddles.slice(0, 3).map(s => <SaddleCard saddle={s} />)}
    </div>
  </section>
</Layout>
EOF

# Create placeholder blank pages
for page in about saddles customization events contact 404; do
  cat > src/pages/${page}.astro << 'EOF'
--- 
import Layout from '../components/Layout.astro';
---
<Layout title="${page.charAt(0).toUpperCase() + page.slice(1)}">
  <div class="container mx-auto py-12 prose lg:prose-xl">
    <h1>${page.charAt(0).toUpperCase() + page.slice(1)}</h1>
    <p>Contenu à personnaliser ici…</p>
  </div>
</Layout>
EOF
done

# global.css
cat > public/global.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

echo "✅ Structure générée."
echo "Place les images (logo.png, hero.jpg, saddle*.jpg) dans public/images/."
echo "Remplace YOUR_FORM_ID dans ContactForm.astro."
