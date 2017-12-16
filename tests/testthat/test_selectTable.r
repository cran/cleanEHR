context("Testing table selection")

pseudoepisode <- function(n, with.meta=FALSE) {
    ep <- list(NIHR_HIC_ICU_0108=data.frame(time=as.numeric(seq(0, 19)), 
                                      item2d=rep(80, 20)), 
         NIHR_HIC_ICU_0002="site_i", 
         NIHR_HIC_ICU_0005="episode_i"
         )
    if (with.meta)
        ep[["NIHR_HIC_ICU_0441"]] <- data.frame(time=as.numeric(seq(0, 9)), 
                                                item2d=seq(10), 
                                                meta=rep("I", 10), 
                                                stringsAsFactors=FALSE)
    cr <- ccRecord()
    for (i in seq(n)) 
        cr <- cr + new.episode(ep)
    cr
}




test_that("",{
    itemsToDataFrame(ccdt@episodes[[1]], "NIHR_HIC_ICU_0108", 2, 1)
})



test_that("",{
    ccd_select_table(ccdt, items_opt="NIHR_HIC_ICU_0108", freq=1)
})


test_that("test if drugs meta data can be re-generated when the drug itself 
          is not presented.", {
    # using meropenem 0441 as an example. 
    cr <- pseudoepisode(1, with.meta=FALSE)
    tb <- ccd_select_table(cr, items_opt="NIHR_HIC_ICU_0441", freq=1)
    expect_true("NIHR_HIC_ICU_0441" %in% names(tb))
    expect_true("NIHR_HIC_ICU_0441.meta" %in% names(tb))
    expect_equivalent(tb$NIHR_HIC_ICU_0441, rep(as.numeric(NA), 20))
    expect_equivalent(tb$NIHR_HIC_ICU_0441.meta, rep("NA", 20))
})


test_that("when drug data is presented, to see whether it can be correctly
           loaded", {
    cr <- pseudoepisode(1, with.meta=TRUE)
    tb <- ccd_select_table(cr, items_opt="NIHR_HIC_ICU_0441", freq=1)
    expect_true("NIHR_HIC_ICU_0441" %in% names(tb))
    expect_true("NIHR_HIC_ICU_0441.meta" %in% names(tb))
    expect_equivalent(tb$NIHR_HIC_ICU_0441, c(seq(10), rep(NA, 10)))
    expect_equivalent(as.character(tb$NIHR_HIC_ICU_0441.meta), 
                      c(rep("I", 10), rep("NA", 10)))
})

