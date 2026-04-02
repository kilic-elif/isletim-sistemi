function updateTime() {
    const now = new Date();
    
    // Saat (HH:MM)
    let hours = now.getHours().toString().padStart(2, '0');
    let minutes = now.getMinutes().toString().padStart(2, '0');
    document.getElementById('clock').innerText = `${hours}:${minutes}`;
    
    // Tarih (DD.MM.YYYY)
    let day = now.getDate().toString().padStart(2, '0');
    let month = (now.getMonth() + 1).toString().padStart(2, '0');
    let year = now.getFullYear();
    document.getElementById('date').innerText = `${day}.${month}.${year}`;
}

setInterval(updateTime, 1000);
updateTime();

// Şarj (Batarya) Durumunu Güncelle
if ('getBattery' in navigator) {
    navigator.getBattery().then(function(battery) {
        function updateBattery() {
            let level = Math.round(battery.level * 100);
            document.getElementById('battery-text').innerText = level + '%';
        }
        
        updateBattery();
        battery.addEventListener('levelchange', updateBattery);
    });
}
