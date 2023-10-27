String doorSysHtml = '''<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ajtónyitó rendszer</title>
    <script>
        function doorOpen() {
            const jelszo = prompt("Kérem a jelszót: ");
            if (jelszo == "*********") {
               window.location.href = "shutdown";
            } else {
                alert("Hibás jelszó!");
            }
        }
    </script>
</head>

<body>
    <h1 style="text-align: center;">ajtónyitó vezérlő</h1>
    <div style="text-align: center;margin-top:30px">
        <p>Jelenlegi ajók száma: ???</p>
        <p>Ajtók állapota: ???</p>
        <p>Felhasználók száma: ???</p>
        <br>
        <p>Rendszer állapota: <span style="color: red">KRITIKUS</span></p>
        <br>
        <button type="button" style="padding: 10px; cursor: pointer;" onclick="doorOpen()">LEÁLLÍTÁS ÉS AJTÓK KINYÍTÁSA</button>
    </div>
</html>''';
