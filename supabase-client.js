// ============================================================
// AZAD PROVISION STORE — Supabase Client
// Replace SUPABASE_URL and SUPABASE_ANON_KEY with your values
// from: https://supabase.com → your project → Settings → API
// ============================================================

// ⚠️ REPLACE THESE TWO VALUES AFTER CREATING YOUR SUPABASE PROJECT:
const SUPABASE_URL = 'https://oeaovksviehntmyjqoik.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9lYW92a3N2aWVobnRteWpxb2lrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI3NTIwOTIsImV4cCI6MjA5ODMyODA5Mn0.yDl2BfatbGMBdZURut3kFTYKowOkRccXoltFklEXyJ8';

const { createClient } = supabase;
const sb = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// WhatsApp number (no + sign, with country code)
const WHATSAPP_NUMBER = '919876543210'; // ⚠️ Update to real number

// Open WhatsApp with a pre-filled message
function openWhatsApp(message = 'Hello! I would like to place an order.') {
  const encoded = encodeURIComponent(message);
  window.open(`https://wa.me/${WHATSAPP_NUMBER}?text=${encoded}`, '_blank');
}

// Format price as Indian Rupees
function formatPrice(amount) {
  return '₹' + Number(amount).toLocaleString('en-IN', { minimumFractionDigits: 2 });
}

// Get full image URL from Supabase storage or return placeholder
function getImageUrl(path, bucket = 'product-images') {
  if (!path) return 'https://placehold.co/400x400/e8e8e8/999?text=Photo';
  if (path.startsWith('http')) return path;
  return `${SUPABASE_URL}/storage/v1/object/public/${bucket}/${path}`;
}

// Show a simple toast notification at bottom of screen
function showToast(message, type = 'success') {
  const existing = document.getElementById('_toast');
  if (existing) existing.remove();
  const toast = document.createElement('div');
  toast.id = '_toast';
  toast.textContent = message;
  toast.style.cssText = `
    position:fixed;bottom:24px;left:50%;transform:translateX(-50%);
    background:${type === 'success' ? '#22c55e' : '#ef4444'};
    color:#fff;padding:14px 28px;border-radius:10px;font-size:15px;
    font-weight:600;z-index:9999;box-shadow:0 4px 16px rgba(0,0,0,.25);
    white-space:nowrap;
  `;
  document.body.appendChild(toast);
  setTimeout(() => toast.remove(), 3500);
}

// Show "Loading..." inside a container while data fetches
function showLoading(id) {
  const el = document.getElementById(id);
  if (el) el.innerHTML = '<p style="text-align:center;padding:40px;color:#888">Loading...</p>';
}
