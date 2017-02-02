context("Testing data quality report")


test_that("file level summary",{
    expect_equal(nrow(file.summary(ccd)), length(unique(ccd@infotb$parse_file)))
})


test_that("table1", {
    demg <- suppressWarnings(sql.demographic.table(ccd))
    table1(demg, "SEX", return.data=T)
    expect_error(table1(demg, "non_nhic", return.data=T))
    expect_error(table1(demg, "h_rate", return.data=T)) # need to be categorical data
})


test_that("demographic data completeness", {
    demg <- suppressWarnings(sql.demographic.table(ccd))
    tb <- demographic.data.completeness(demg, return.data=T)
    ndemg <- length(which(sapply(cleanEHR:::ITEM_REF, function(x) 
                                 x$Classification1=="Demographic")))
    expect_equal(nrow(tb), ndemg)
})


test_that("calculate total data point", {
    expect_equal(total.data.point(ccd), 16)
})

test_that("episode graph", {
})


test_that("calculate 2D sample rate", {
    tb <- create.cctable(ccdt, conf=list(NIHR_HIC_ICU_0108=list()), freq=1)
    capture.output(samplerate2d(tb$torigin))
})
