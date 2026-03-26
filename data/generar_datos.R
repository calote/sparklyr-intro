# generar_datos.R — ejecutar una vez para crear el CSV
set.seed(42)
n <- 500000

vuelos <- tibble::tibble(
  vuelo_id     = 1:n,
  aerolinea    = sample(c("IB", "VY", "FR", "LH", "AF", "BA"), n, replace = TRUE,
                        prob = c(0.25, 0.20, 0.20, 0.15, 0.10, 0.10)),
  origen       = sample(c("MAD", "BCN", "LIS", "CDG", "FCO", "LHR"), n, replace = TRUE),
  destino      = sample(c("MAD", "BCN", "LIS", "CDG", "FCO", "LHR"), n, replace = TRUE),
  fecha        = sample(seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"),
                        n, replace = TRUE),
  hora_prog    = round(runif(n, 5, 23), 2),
  retraso_min  = round(pmax(-10, rnorm(n, mean = 15, sd = 30)), 1),
  pasajeros    = sample(50:220, n, replace = TRUE),
  precio_medio = round(runif(n, 35, 450), 2),
  cancelado    = sample(c(0L, 1L), n, replace = TRUE, prob = c(0.94, 0.06))
)

# Introducir NA realistas
vuelos$retraso_min[sample(n, n * 0.03)]  <- NA
vuelos$precio_medio[sample(n, n * 0.02)] <- NA

# Eliminar vuelos con mismo origen y destino
vuelos <- dplyr::filter(vuelos, origen != destino)

readr::write_csv(vuelos, "data/vuelos_2024.csv")
