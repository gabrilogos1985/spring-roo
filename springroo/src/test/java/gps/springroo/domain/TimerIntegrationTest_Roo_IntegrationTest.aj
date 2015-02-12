// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package gps.springroo.domain;

import gps.springroo.domain.Timer;
import gps.springroo.domain.TimerDataOnDemand;
import gps.springroo.domain.TimerIntegrationTest;
import java.util.Iterator;
import java.util.List;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect TimerIntegrationTest_Roo_IntegrationTest {
    
    declare @type: TimerIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: TimerIntegrationTest: @ContextConfiguration(locations = "classpath*:/META-INF/spring/applicationContext*.xml");
    
    declare @type: TimerIntegrationTest: @Transactional;
    
    @Autowired
    TimerDataOnDemand TimerIntegrationTest.dod;
    
    @Test
    public void TimerIntegrationTest.testCountTimers() {
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", dod.getRandomTimer());
        long count = Timer.countTimers();
        Assert.assertTrue("Counter for 'Timer' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void TimerIntegrationTest.testFindTimer() {
        Timer obj = dod.getRandomTimer();
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Timer' failed to provide an identifier", id);
        obj = Timer.findTimer(id);
        Assert.assertNotNull("Find method for 'Timer' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'Timer' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void TimerIntegrationTest.testFindAllTimers() {
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", dod.getRandomTimer());
        long count = Timer.countTimers();
        Assert.assertTrue("Too expensive to perform a find all test for 'Timer', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<Timer> result = Timer.findAllTimers();
        Assert.assertNotNull("Find all method for 'Timer' illegally returned null", result);
        Assert.assertTrue("Find all method for 'Timer' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void TimerIntegrationTest.testFindTimerEntries() {
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", dod.getRandomTimer());
        long count = Timer.countTimers();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<Timer> result = Timer.findTimerEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'Timer' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'Timer' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void TimerIntegrationTest.testFlush() {
        Timer obj = dod.getRandomTimer();
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Timer' failed to provide an identifier", id);
        obj = Timer.findTimer(id);
        Assert.assertNotNull("Find method for 'Timer' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyTimer(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'Timer' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void TimerIntegrationTest.testMergeUpdate() {
        Timer obj = dod.getRandomTimer();
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Timer' failed to provide an identifier", id);
        obj = Timer.findTimer(id);
        boolean modified =  dod.modifyTimer(obj);
        Integer currentVersion = obj.getVersion();
        Timer merged = obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'Timer' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void TimerIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", dod.getRandomTimer());
        Timer obj = dod.getNewTransientTimer(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'Timer' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'Timer' identifier to be null", obj.getId());
        try {
            obj.persist();
        } catch (final ConstraintViolationException e) {
            final StringBuilder msg = new StringBuilder();
            for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                final ConstraintViolation<?> cv = iter.next();
                msg.append("[").append(cv.getRootBean().getClass().getName()).append(".").append(cv.getPropertyPath()).append(": ").append(cv.getMessage()).append(" (invalid value = ").append(cv.getInvalidValue()).append(")").append("]");
            }
            throw new IllegalStateException(msg.toString(), e);
        }
        obj.flush();
        Assert.assertNotNull("Expected 'Timer' identifier to no longer be null", obj.getId());
    }
    
    @Test
    public void TimerIntegrationTest.testRemove() {
        Timer obj = dod.getRandomTimer();
        Assert.assertNotNull("Data on demand for 'Timer' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Timer' failed to provide an identifier", id);
        obj = Timer.findTimer(id);
        obj.remove();
        obj.flush();
        Assert.assertNull("Failed to remove 'Timer' with identifier '" + id + "'", Timer.findTimer(id));
    }
    
}
