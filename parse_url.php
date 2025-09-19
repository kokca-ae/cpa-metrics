<?php

class URLParser
{
    //Список известных двойных TLD
    private static array $knownDoubleTlds = [
        'co.uk', 'com.au', 'gov.ru', 'org.uk', 'net.au', 'ac.uk', 'co.jp'
    ];

    public static function parse(string $url): array
    {
        $result = [
            'scheme' => null,
            'host' => null,
            'port' => null,
            'user' => null,
            'pass' => null,
            'path' => null,
            'file' => null,
            'extension' => null,
            'query' => null,
            'query_params' => [],
            'fragment' => null,
            'subdomain' => null,
            'domain' => null,
            'tld' => null
        ];

        // Схема
        if (preg_match('#^(?P<scheme>[a-z][a-z0-9+\-.]*)://#i', $url, $matches)) {
            $result['scheme'] = strtolower($matches['scheme']);
            $url = substr($url, strlen($matches[0]));
        }

        // Фрагмент
        if (strpos($url, '#') !== false) {
            [$url, $result['fragment']] = explode('#', $url, 2);
        }

        // Query
        if (strpos($url, '?') !== false) {
            [$url, $result['query']] = explode('?', $url, 2);
            parse_str($result['query'], $result['query_params']);
        }

        // User и pass
        if (preg_match('#^(?P<user>[^:@]+)(:(?P<pass>[^@]*))?@#', $url, $matches)) {
            $result['user'] = $matches['user'];
            $result['pass'] = $matches['pass'] ?? null;
            $url = substr($url, strlen($matches[0]));
        }

        // Host и port
        if (preg_match('#^(?P<host>[^/:]+)(:(?P<port>\d+))?#', $url, $matches)) {
            $result['host'] = strtolower($matches['host']);
            $result['port'] = isset($matches['port']) ? (int)$matches['port'] : null;
            $url = substr($url, strlen($matches[0]));
        }

        // Path, file, extension
        $result['path'] = $url ?: '/';
        $pathParts = explode('/', $result['path']);
        $lastPart = end($pathParts);
        if (strpos($lastPart, '.') !== false) {
            $result['file'] = $lastPart;
            $extParts = explode('.', $lastPart);
            $result['extension'] = end($extParts);
        }

        // Subdomain, domain, tld
        if ($result['host']) {
            $hostParts = explode('.', $result['host']);
            $count = count($hostParts);
            if ($count >= 2) {
                $lastTwo = implode('.', array_slice($hostParts, -2));
                if (in_array($lastTwo, self::$knownDoubleTlds)) {
                    $result['tld'] = $lastTwo;
                    $result['domain'] = $hostParts[$count - 3] ?? null;
                    $result['subdomain'] = $count > 3 ? implode('.', array_slice($hostParts, 0, $count - 3)) : null;
                } else {
                    $result['tld'] = $hostParts[$count - 1];
                    $result['domain'] = $hostParts[$count - 2];
                    $result['subdomain'] = $count > 2 ? implode('.', array_slice($hostParts, 0, $count - 2)) : null;
                }
            } else {
                $result['domain'] = $result['host'];
            }
        }

        return $result;
    }
}

// Пример
$url = "https://user:pass@sub.example.co.uk:8080/path/to/file.php?x=1&y=2#anchor";
print_r(URLParser::parse($url));
