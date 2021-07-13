library(tidyverse)
library(rorcid)
library(here)
library(glue)

# Initiate template

headers <- read_csv(here("data", "entries_template.csv"))

write_csv(headers, here("data", "entries.csv"))

# Rorchid Import

education <- bind_rows(
    orcid_educations("0000-0002-6240-6212")$`0000-0002-6240-6212`$`affiliation-group`$summaries
    ) %>% 
    mutate(
        section = "education",
        institution = glue("{\`education-summary.organization.address.city\`}, {\`education-summary.organization.address.region\`}"),
        start = "",
        description_1 = "",
        description_2 = "",
        description_3 = "",
        description_4 = "",
        description_5 = "",
        in_resume = TRUE
    ) %>%
    select(
        section,
        title = `education-summary.role-title`,
        loc = `education-summary.organization.name`,
        institution,
        start = `education-summary.start-date.year.value`,
        end = `education-summary.end-date.year.value`,
        description_1,
        description_2,
        description_3,
        description_4,
        description_5,
        in_resume
    )

awards <- bind_rows(
    orcid_distinctions("0000-0002-6240-6212")$`0000-0002-6240-6212`$`affiliation-group`$summaries
    ) %>% 
    tibble(
    ) %>%
    mutate(
        section = "awards",
        institution = "",
        start = "",
        description_1 = "",
        description_2 = "",
        description_3 = "",
        description_4 = "",
        description_5 = "",
        in_resume = TRUE
    ) %>%
    select(
        section,
        title = `distinction-summary.role-title`,
        loc = `distinction-summary.organization.name`,
        institution,
        start,
        end = `distinction-summary.start-date.year.value`,
        description_1,
        description_2,
        description_3,
        description_4,
        description_5,
        in_resume
    ) 

pubs <- bind_rows(
    orcid_works("0000-0002-6240-6212")$`0000-0002-6240-6212`$works
) %>%
    tibble(
    ) %>%
    mutate(
        section = "pubs",
        institution = "",
        start = "",
        description_1 = "",
        description_2 = glue("DOI: [{stringr::str_remove(url.value, 'https://doi.org/')}]({url.value})"),
        description_3 = "",
        description_4 = "",
        description_5 = "",
        in_resume = TRUE
    ) %>%
    filter(
        !is.na(`title.translated-title.value`)
    ) %>%
    select(
        `section`,
        title = `title.title.value`,
        loc = `journal-title.value`,
        institution,
        start,
        end = `publication-date.year.value`,
        description_1 = `title.translated-title.value`,
        description_2,
        description_3,
        description_4,
        description_5,
        in_resume
    )

employment <- bind_rows(
    orcid_employments("0000-0002-6240-6212")$`0000-0002-6240-6212`$`affiliation-group`$summaries
) %>% 
    tibble(
    ) %>%
    mutate(
        section = "employment",
        institution = glue("{\`employment-summary.organization.address.city\`}, {\`employment-summary.organization.address.region\`}"),
        start = "",
        description_1 = "",
        description_2 = "",
        description_3 = "",
        description_4 = "",
        description_5 = "",
        in_resume = TRUE
    ) %>%
    select(
        section,
        title = `employment-summary.role-title`,
        loc = `employment-summary.organization.name`,
        institution,
        start = `employment-summary.start-date.year.value`,
        end = `employment-summary.end-date.year.value`,
        description_1,
        description_2,
        description_3,
        description_4,
        description_5,
        in_resume
    )

# Zebra Crossings
employment[1, 7:8] <- list("Worked at Camp Spinnaker, a week-long overnight camp organized by Zebra Crossings for children ages 8-12 with asthma",
                           "Directly supervised eight boys in activities including hikes, boating, ropes courses, asthma education, and self-reflection")

# FDA
employment[2, 7:10] <- list("Worked as research assistant in vaccine research laboratory",
                           "Designed, cloned, and expressed several markerless insertion/deletion mutations in Staphylococcus",
                           "Generated large pool of Staphylococcus mutants via transposon mutagenesis",
                           "Developed prospective in vitro model of Staphyloccus/influenza co-infection in human lung cells")

# Kenyon Library
employment[3, 7] <- list("Offered technical support for computer, software, audio/visual, and printing services")

# Cook Pharmica
employment[4, 7:8] <- list("Worked as lab intern in quality control at a private pharmaceutical contractor",
                           "Designed and implemented a verification study for measuring water content in pharmacological raw materials")

# TEAMeffort
employment[5, 7:8] <- list("Worked as counselor and work site coordinator at rustic youth camp in Arkansas",
                           "Guided visiting youth groups through basic home rehabilitation projects for low-income families")


combined <- bind_rows(education, 
                      awards,
                      pubs,
                      employment)

write_csv(combined,
          here("data", "entries.csv"),
          append = TRUE,
          na = "")


