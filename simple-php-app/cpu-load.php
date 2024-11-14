<?php
// Rozpocznij pomiar czasu
$start = microtime(true);

$result = 0;
for ($i = 0; $i < 1000000000; $i++) {
    $result += sqrt($i); // Oblicz pierwiastek kwadratowy liczby i i dodaj do wyniku
}

// Zakończ pomiar czasu
$end = microtime(true);

// Oblicz czas wykonania
$executionTime = $end - $start;

// Wyświetl czas wykonania
echo "Czas wykonania sqrt: $executionTime sekund";
?>
