# Figure 4c-g shows the code used for deltaC condition
# Similar code can be adapted for the other panels with corresponding changes

pdf('AK2_DLS_condition_deltaC_test.pdf', width = 8, height = 7, pointsize = 10)

par(mar = c(3, 3, 1, 1) + 0.1, bty = "L", mgp = c(2, 0.5, 0), tcl = -0.3)

# Plot main dataset
plot(AK2_WT$Time, AK2_WT$DC,
     type = "p", col = 'red',
     xlim = c(0, 4.9e5), ylim = c(0.2, 1.2),
     xlab = "Time", ylab = "Intensity")

# Error bars for DC (deltaC)
arrows(AK2_WT$Time, AK2_WT$DC - AK2_WT$DC.S.D,
       AK2_WT$Time, AK2_WT$DC + AK2_WT$DC.S.D,
       code = 3, angle = 90, length = 0.1, col = 'red')

# AK2.1
points(AK2_WT$Time, AK2_WT$AK2.1, col = 'cyan2')
arrows(AK2_WT$Time, AK2_WT$AK2.1 - AK2_WT$AK2.1.S.D,
       AK2_WT$Time, AK2_WT$AK2.1 + AK2_WT$AK2.1.S.D,
       code = 3, angle = 90, length = 0.1, col = 'cyan2')

# AK2.2
points(AK2_WT$Time, AK2_WT$AK2.2, col = 'grey')
arrows(AK2_WT$Time, AK2_WT$AK2.2 - AK2_WT$AK2.2.S.D,
       AK2_WT$Time, AK2_WT$AK2.2 + AK2_WT$AK2.2.S.D,
       code = 3, angle = 90, length = 0.1, col = 'grey')

# Add legend
legend("topright", legend = c("deltaC", "AK2.1", "AK2.2"),
       col = c("red", "cyan2", "grey"), pch = 1, bty = "n")

box()
dev.off()