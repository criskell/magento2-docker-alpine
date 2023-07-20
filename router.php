<?php

$httpHost = getenv("HTTP_HOST");

if (! empty($httpHost)) {
    $_SERVER["HTTP_HOST"] = $httpHost;
}

return require __DIR__ . "/web/phpserver/router.php";