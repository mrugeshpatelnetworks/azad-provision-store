// ============================================================
// AZAD PROVISION STORE — Auth Guard
// Include this on every admin and vendor page (after supabase-client.js)
// to redirect unauthenticated or wrong-role users back to login.
// ============================================================

// Expected role: 'admin' or 'vendor'
// Set window.REQUIRED_ROLE before including this script, e.g.:
//   <script>window.REQUIRED_ROLE = 'admin';</script>

(async function authGuard() {
  const { data: { session } } = await sb.auth.getSession();

  if (!session) {
    // Not logged in at all → go to appropriate login page
    const loginPage = (window.REQUIRED_ROLE === 'vendor') ? '/vendor/login.html' : '/admin/login.html';
    window.location.href = loginPage;
    return;
  }

  const role = session.user?.user_metadata?.role;

  if (window.REQUIRED_ROLE && role !== window.REQUIRED_ROLE) {
    // Wrong role → kick back to their own login
    await sb.auth.signOut();
    const loginPage = (window.REQUIRED_ROLE === 'vendor') ? '/vendor/login.html' : '/admin/login.html';
    window.location.href = loginPage;
    return;
  }

  // Store session globally for convenience
  window.currentUser = session.user;
  window.currentRole = role;

  // Show user name if an element with id="user-name" exists
  const nameEl = document.getElementById('user-name');
  if (nameEl) {
    nameEl.textContent = session.user?.user_metadata?.full_name || session.user.email;
  }
})();

// Logout function — call from any logout button
async function logout() {
  await sb.auth.signOut();
  const loginPage = (window.REQUIRED_ROLE === 'vendor') ? '/vendor/login.html' : '/admin/login.html';
  window.location.href = loginPage;
}
