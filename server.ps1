$port = 8080
$address = [System.Net.IPAddress]::Any
$endpoint = New-Object System.Net.IPEndPoint ($address, $port)
$socket = New-Object System.Net.Sockets.TcpListener ($endpoint)

# Get local IP address
$ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Wi-Fi' | Select-Object -ExpandProperty IPAddress)
if (-not $ip) {
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notmatch "127.0.0.1" } | Select-Object -First 1 -ExpandProperty IPAddress)
}

$socket.Start()
Write-Host "Server started on all interfaces!"
Write-Host "Access from computer: http://localhost:$port/"
Write-Host "Access from phone: http://$($ip):$port/"

while ($true) {
    try {
        $client = $socket.AcceptTcpClient()
        $stream = $client.GetStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $line = $reader.ReadLine()
        
        if ($line -match "GET /(\S*) HTTP") {
            $path = $matches[1]
            $path = $path -replace '\?.*$', ''
            if ($path -eq "" -or $path -eq "/") { $path = "index.html" }
            $localPath = Join-Path (Get-Location) $path
            
            if (Test-Path $localPath -PathType Leaf) {
                $content = [IO.File]::ReadAllBytes($localPath)
                $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
                $type = switch ($ext) { ".html"{"text/html"}; ".css"{"text/css"}; ".js"{"application/javascript"}; ".png"{"image/png"}; default{"application/octet-stream"} }
                
                $header = "HTTP/1.1 200 OK`r`nContent-Type: $type; charset=utf-8`r`nContent-Length: $($content.Length)`r`nCache-Control: no-cache, no-store, must-revalidate`r`nPragma: no-cache`r`nExpires: 0`r`nConnection: close`r`n`r`n"
                $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($header)
                $stream.Write($headerBytes, 0, $headerBytes.Length)
                $stream.Write($content, 0, $content.Length)
            } else {
                $header = "HTTP/1.1 404 Not Found`r`nContent-Length: 0`r`nConnection: close`r`n`r`n"
                $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($header)
                $stream.Write($headerBytes, 0, $headerBytes.Length)
            }
        }
        $stream.Flush()
        $client.Close()
    } catch {
        # Silent catch to prevent server crash on broken pipe
    }
}
