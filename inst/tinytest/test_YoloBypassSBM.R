## Started out with good intentions of having good test coverage
## but writing tests slipped to a lower priority
## also, because many of the functions are just looking up data,
## the tests are not robust to changes in the underlying data

# dates ----------------------------------------------------------

expect_equal(get_water_year(c(1, 365, 730)), c(1997, 1998, 1999))
expect_equal(get_yday(c(1, 365, 730)), c(276, 274, 274))
expect_error(get_yday(0))
expect_equal(get_wy_yday(c(1, 365, 730)), c(2, 1, 1))
expect_error(get_wy_yday(5383))

# initialize cohorts ----------------------------------------------------------

expect_error(initialize_cohort("Summer"))
expect_equal(floor(initial_cohort_fork_length(100, "Winter", "deterministic")), 95)
expect_equal(floor(initial_cohort_fork_length(100, "Spring", "deterministic")), 46)
expect_equal(floor(initial_cohort_fork_length(1000, "LateFall", "deterministic")), 34)
expect_equal(floor(initial_cohort_fork_length(1200, "LateFall", "deterministic")), 128)

expect_error(initial_cohort_abundance(1990))
expect_equal(sum(initial_cohort_abundance(2000, "Fall", "deterministic")),
             annual_abundance[["Fall"]][annual_abundance[["WaterYear"]] == 2000])
expect_equal(sum(initial_cohort_abundance(2001, "LateFall", "deterministic")),
             annual_abundance[["LateFall"]][annual_abundance[["WaterYear"]] == 2001])
expect_equal(sum(initial_cohort_abundance(2002, "Winter", "deterministic")),
             annual_abundance[["Winter"]][annual_abundance[["WaterYear"]] == 2002])
expect_equal(sum(initial_cohort_abundance(2003, "Spring", "deterministic")),
             annual_abundance[["Spring"]][annual_abundance[["WaterYear"]] == 2003])

# entrainment ----------------------------------------------------------

expect_equal(sum(unlist(entrainment(100, 1000, "Exg", "deterministic"))), 1000)
expect_equal(sum(unlist(entrainment(100, 10000, "Exg", "deterministic"))), 10000)
expect_equal(round(entrainment(120, 10000, "Exg", "deterministic")$Yolo), 8735)
expect_equal(round(entrainment(120, 10000, "Exg", "deterministic")$Sac), 1265)

# survival ----------------------------------------------------------

# rearing
expect_equal(round(rearing_survival(1, "deterministic"), 2), 0.99)
expect_equal(round(rearing_survival(10, "deterministic"), 2), 0.9)
expect_equal(round(rearing_survival(20, "deterministic"), 2), 0.82)

# passage
expect_equal(round(passage_survival(1000, 70, 60000, "Sac", "deterministic")), 490)
expect_equal(round(passage_survival(1000, 70, 60000, "Yolo", "deterministic")), 339)
expect_equal(round(passage_survival(1000, 150, 60000, "Sac", "deterministic")), 694)
expect_equal(round(passage_survival(1000, 150, 60000, "Yolo", "deterministic")), 547)
expect_equal(round(passage_survival(1000, 70, 30000, "Sac", "deterministic")), 324)
expect_equal(round(passage_survival(1000, 70, 30000, "Yolo", "deterministic")), 203)

# passage time ----------------------------------------------------------

expect_equal(round(passage_time(70, 60000, "Sac", "deterministic"), 1), 4.6)
expect_equal(round(passage_time(70, 60000, "Yolo", "deterministic"), 1), 6.6)

# inv_logit ----------------------------------------------------------

expect_equal(inv_logit(-Inf), 0)
expect_equal(inv_logit(Inf), 1)
expect_equal(inv_logit(0), 0.5)
expect_equal(round(inv_logit(-0.5), 2), 0.38)
expect_equal(round(inv_logit(0.5), 2), 0.62)
