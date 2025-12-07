function diagnostic_dns
    echo "=== Diagnóstico DNS ==="
    echo ""
    echo "1. Estado de dnsmasq:"
    sudo systemctl status dnsmasq --no-pager | head -5
    echo ""
    echo "2. Puerto 53:"
    sudo ss -tulpn | grep :53
    echo ""
    echo "3. /etc/resolv.conf:"
    cat /etc/resolv.conf
    echo ""
    echo "4. Configuración dnsmasq:"
    sudo cat /etc/dnsmasq.conf | grep -v '^#' | grep -v '^$'
    echo ""
    echo "5. Probar resolución:"
    echo -n "gitlab.dev.local: "
    getent hosts gitlab.dev.local; or echo "NO RESUELVE"
    echo ""
    echo "6. Logs recientes de dnsmasq:"
    sudo journalctl -u dnsmasq -n 10 --no-pager
end

function sluggify
    echo $argv[1] \
        | iconv -t ascii//TRANSLIT \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9]/-/g; s/-\+/-/g; s/^-//; s/-$//'
end

function k8l 
    if test (count $argv) -lt 1
        k8 logs $(k8 get pods -o name|fzf)
    else
        k8 logs $(k8p $argv[1])
    end
end
