function login() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    
    if (username === 'admin' && password === '123456') {
      window.location.href = 'pages/dashboard.html';
    } else {
      alert('账号或密码错误');
    }
  }
  