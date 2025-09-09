# Personal Website — Pablo Grobas Illobre

This is the source code of my personal website, built using Elixir and the Phoenix web framework.  
The site is publicly deployed at: https://www.pgrobasillobre.com

It serves as a digital CV, publication archive, and software showcase.

---

## Features

- Interactive CV viewer
- Section for publications
- Software projects overview
- Responsive design using Tailwind CSS
- Production-ready Phoenix LiveView app

---

## Getting Started

To run this project locally:

### 1. Prerequisites

- Elixir and Phoenix installed  
- Docker installed and running

---

### 2. Clone the Repository

```bash
git clone https://github.com/pgrobasillobre/personal_website.git
cd personal_website
```

---

### 3. Set up the Dockerized Database

```bash
mix docker.setup
```

If the database is already created, you can restart it with:

```bash
docker restart personal_website_db
```

---

### 4. Set up the Database Schema

```bash
mix ecto.setup
```

---

### 5. Install and Build Assets

```bash
mix assets.setup
mix assets.build
mix assets.deploy
```

---

### 6. Run the Server

```bash
iex -S mix phx.server
```

Then navigate to http://localhost:4000 in your browser.



