# Azad Provision Store — Website Project

Family-run FMCG store in Ambavadi, Ahmedabad, Gujarat since the 1990s.

---

## Project Structure

```
azad-provision-store/
├── public/                    ← Customer-facing pages (from Gemini)
│   ├── index.html
│   ├── products.html
│   ├── deals.html
│   ├── about.html
│   └── contact.html
│
├── admin-login.html           ← Store owner login (mobile-first)
├── admin-dashboard.html       ← Owner home screen
├── admin-add-product.html     ← Add/edit products
├── admin-products.html        ← View all products
├── admin-deals.html           ← Manage deals
├── admin-vendor-offers.html   ← Approve/reject vendor submissions
│
├── vendor-login.html          ← Vendor login
├── vendor-dashboard.html      ← Vendor home
├── vendor-submit-deal.html    ← Submit a deal for approval
│
├── supabase-client.js         ← Shared Supabase client (update URL + key here!)
├── auth-guard.js              ← Auth protection for admin/vendor pages
├── schema.sql                 ← Run once in Supabase SQL editor
└── README.md
```

---

## Setup Steps

### Step 1 — Create Supabase Project

1. Go to https://supabase.com and sign up (free)
2. Click "New Project" — name it `azad-provision-store`
3. Choose the Mumbai (ap-south-1) region for fastest load times in India
4. Wait ~2 minutes for it to set up

### Step 2 — Run the Database Schema

1. In Supabase, click "SQL Editor" in the left menu
2. Paste the entire contents of `schema.sql` and click "Run"
3. You should see "Success" — this creates all tables + sample categories

### Step 3 — Create Storage Buckets

1. In Supabase, click "Storage"
2. Create bucket: `product-images` — set to **Public**
3. Create bucket: `deal-images` — set to **Public**

### Step 4 — Create the Admin Account (Dad)

1. In Supabase, click "Authentication" → "Users" → "Invite User"
2. Enter Dad's email address
3. After he creates his password, go to that user in the list
4. Click the user → "Edit user" → add to "User Metadata":
   ```json
   { "role": "admin", "full_name": "Owner Name Here" }
   ```

### Step 5 — Create Vendor Accounts

For each vendor/supplier:
1. Supabase → Authentication → Users → Invite User
2. Enter vendor's business email
3. After they set password, edit their metadata:
   ```json
   { "role": "vendor", "full_name": "Company Name" }
   ```

### Step 6 — Configure the Website

1. Open `supabase-client.js`
2. Replace `YOUR_PROJECT_ID` with your Supabase project ID
   (found in Supabase → Settings → API → Project URL)
3. Replace `YOUR_ANON_PUBLIC_KEY` with your anon/public key
   (found in Supabase → Settings → API → anon public)
4. Update `WHATSAPP_NUMBER` to Dad's actual WhatsApp number (with country code, no + sign)

### Step 7 — Upload to GitHub

1. Create a GitHub account at https://github.com
2. Create a new repository: `azad-provision-store`
3. Upload all these files to the repository
4. Enable GitHub Pages: Settings → Pages → Branch: main → Save

### Step 8 — Connect Your Domain

1. In GitHub Pages settings, add your custom domain
2. In your domain registrar (GoDaddy/BigRock etc), add CNAME record pointing to GitHub Pages

---

## Pages Reference

| URL | Who uses it | Purpose |
|---|---|---|
| `/` or `/index.html` | Customers | Homepage with products & deals |
| `/products.html` | Customers | Browse all products |
| `/deals.html` | Customers | Current offers |
| `/about.html` | Customers | Store story |
| `/contact.html` | Customers | Contact & WhatsApp |
| `/admin-login.html` | Store owner | Login |
| `/admin-dashboard.html` | Store owner | Main menu |
| `/admin-add-product.html` | Store owner | Add a product |
| `/admin-products.html` | Store owner | View/edit products |
| `/admin-deals.html` | Store owner | Manage deals |
| `/admin-vendor-offers.html` | Store owner | Approve vendor deals |
| `/vendor-login.html` | Vendors | Login |
| `/vendor-dashboard.html` | Vendors | View submitted deals |
| `/vendor-submit-deal.html` | Vendors | Submit a new deal |

---

## WhatsApp Ordering Flow

No payment gateway needed. All orders go through WhatsApp:

1. Customer sees a product → taps "Order on WhatsApp"
2. WhatsApp opens with pre-filled message: "Hello! I want to order [product name]..."
3. Dad receives the message and confirms the order
4. Delivery arranged, payment collected Cash on Delivery

---

## Future Upgrades (when ready)

- [ ] Admin can manage categories (add custom ones)
- [ ] Google Analytics for visitor tracking
- [ ] Customer can save wishlist (localStorage)
- [ ] Google Business Profile listing for local SEO
- [ ] Instagram/Facebook shop integration
- [ ] Proper notification when vendor submits (email/SMS)
