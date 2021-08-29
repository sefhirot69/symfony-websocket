<?php

declare(strict_types=1);

namespace App\Websocket;

use Exception;
use Ratchet\ConnectionInterface;
use Ratchet\RFC6455\Messaging\MessageInterface;
use Ratchet\WebSocket\MessageComponentInterface;
use SplObjectStorage;

final class MessageHandler implements MessageComponentInterface
{

    protected $connections;

    /**
     * MessageHandler constructor.
     *
     */
    public function __construct()
    {

        $this->connections = new SplObjectStorage();
    }

    public function onOpen(ConnectionInterface $conn): void
    {

        $this->connections->attach($conn);
    }

    public function onClose(ConnectionInterface $conn): void
    {

        $this->connections->detach($conn);
    }

    public function onError(ConnectionInterface $conn, Exception $e): void
    {

        $this->connections->detach($conn);
        $conn->close();
    }

    /**
     * @param ConnectionInterface $conn
     * @param MessageInterface    $msg
     */
    public function onMessage(ConnectionInterface $conn, MessageInterface $msg): void
    {

        foreach ($this->connections as $connection) {
            if ($connection === $conn) {
                continue;
            }

            $connection->send($msg);
        }
    }

}