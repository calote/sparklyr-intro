library(dplyr)
library(ggplot2)

vuelos_sp = read.csv("data/vuelos_2024.csv")
str(vuelos_sp)

n_total = nrow(vuelos_sp)

n_cancelados = vuelos_sp |> 
  filter(cancelado == 1) |> 
  nrow()

cat("Vuelos cancelados:", n_cancelados, "\n")
cat("Porcentaje:", round(n_cancelados / n_total * 100, 2), "%\n")


resumen_aerolineas <- vuelos_sp |>
  group_by(aerolinea) |>
  summarise(
    n_vuelos      = n(),
    retraso_medio = mean(retraso_min, na.rm = T),
    pct_cancelado = mean(cancelado, na.rm = T) * 100
  ) |>
  arrange(desc(retraso_medio)) 

resumen_aerolineas


vuelos_enriquecidos <- vuelos_sp |>
  filter(cancelado == 0) |>
  mutate(
    franja_horaria = case_when(
      hora_prog < 7 ~ "madrugada",
      hora_prog < 13 ~ "mañana",
      hora_prog < 20 ~ "tarde",
      TRUE ~ "noche"
    ),
    ingreso_estimado = pasajeros * precio_medio
  ) #|>
  #compute("vuelos_enriquecidos")

# Verificar: mira unas cuantas filas
vuelos_enriquecidos |>
  select(aerolinea, hora_prog, franja_horaria, ingreso_estimado) |>
  head(5) 

ggplot(ingresos, aes(x = aerolinea, y = ingreso_total, fill = franja_horaria)) +
  geom_col(position = "dodge") +
  labs(
    title = "Ingreso estimado por aerolínea y franja horaria",
    x     = "Aerolinea",
    y     = "Ingreso total"
  ) +
  theme_minimal()



ejemplo_ventana <- vuelos_enriquecidos |>
  group_by(aerolinea) |>
  mutate(
    media_aerolinea = mean(retraso_min, na.rm = TRUE),
    desviacion      = retraso_min - media_aerolinea
  ) |>
  ungroup()

# Cada vuelo conserva su fila, pero ahora tiene pegada la media de su grupo.
ejemplo_ventana |>
  select(vuelo_id, aerolinea, retraso_min, media_aerolinea, desviacion) |>
  head(8)


top3_origenes <- vuelos_enriquecidos |>
  # Paso 1: contar
  group_by(aerolinea, origen) |>
  summarise(n_vuelos = n()) |>
  
  # Paso 2: rankear dentro de cada aerolínea
  group_by(aerolinea) |>
  mutate(
    ranking = min_rank(desc(n_vuelos))
  ) |>
  ungroup() |>
  
  # Quedarnos solo con los top 3
  filter(ranking <= 3) |>
  arrange(aerolinea, ranking) 

top3_origenes


vuelos_con_desviacion <- vuelos_enriquecidos |>
  filter(!is.na(retraso_min)) |>
  group_by(aerolinea, franja_horaria) |>
  mutate(
    media_grupo = mean(retraso_min, na.rm = T),
    desviacion  = retraso_min - media_grupo,
    n_en_grupo  = n()
  ) |>
  ungroup()    # <-- no olvides desagrupar

# Top 10 con mayor desviación
top10 <- vuelos_con_desviacion |>
  arrange(desc(desviacion)) |>
  select(vuelo_id, aerolinea, franja_horaria,
         retraso_min, media_grupo, desviacion) |>
  head(10)

top10



tendencia <- vuelos_enriquecidos |>
  # Paso 1: retraso medio por día y aerolínea
  group_by(aerolinea, fecha) |>
  summarise(retraso_medio_dia = mean(retraso_min, na.rm = TRUE)) |>
  
  # Paso 2: función de ventana con lag
  group_by(aerolinea) |>
  arrange(fecha) |>
  mutate(
    retraso_dia_anterior  = lag(retraso_medio_dia, 1),
    cambio_diario = retraso_medio_dia - retraso_dia_anterior
  ) |>
  ungroup() 

# Visualización para la aerolínea "IB" (o la que prefieras)
tendencia |>
  filter(aerolinea == "IB") |>
  ggplot(aes(x = fecha, y = retraso_medio_dia)) +
  geom_line(alpha = 0.4) +
  geom_smooth(se = FALSE, color = "tomato", method = "loess", span = 0.1) + # , method = "loess", span = 0.1
  labs(title = "Evolución del retraso medio diario",
       x = "Fecha", y = "Retraso medio (min)") +
  theme_minimal()
