context("Testing data quality report")


test_that("file level summary",{
    expect_equal(nrow(file.summary(ccd)), length(unique(ccd@infotb$parse_file)))
})


test_that("table1", {
    demg <- suppressWarnings(ccd_demographic_table(ccd))
    table1(demg, "SEX", return.data=TRUE)
    expect_error(table1(demg, "non_nhic", return.data=TRUE))
    expect_error(table1(demg, "h_rate", return.data=TRUE)) # need to be categorical data
})


test_that("demographic data completeness", {
    demg <- suppressWarnings(ccd_demographic_table(ccd))
    tb <- demographic.data.completeness(demg, return.data=TRUE)
    ndemg <- length(which(sapply(cleanEHR:::ITEM_REF, function(x) 
                                 x$Classification1=="Demographic")))
    expect_equal(nrow(tb), ndemg)
})


test_that("calculate total data point", {
    expect_equal(total.data.point(ccd), 25)
})

test_that("ccd_episode_graph", {
})


test_that("calculate 2D sample rate", {
    tb <- create_cctable(ccdt, conf=list(NIHR_HIC_ICU_0108=list()), freq=1)
    capture.output(samplerate2d(tb$torigin))
})
