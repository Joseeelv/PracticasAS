up:
	docker compose up

down:
	docker compose down

restart:
	docker compose down
	docker compose up

console:
	docker compose exec -it wordpress /bin/bash